#!/bin/bash

# Before running this script, make sure you have run the following commands:
# ```
# sh autogen.sh
# sh configure
# python3 generate-darwin-source-and-headers.py --only-ios
# ```
# refer to https://github.com/libffi/libffi
# refer to https://github.com/libffi/libffi/issues/510


readonly SOURCE_DIRECTORIES=("darwin_common" "darwin_ios")
readonly INTERNAL_HEADER_FILE_NAME="internal.h"
readonly SOURCES_DIRECTORY="Sources/libffi_apple"


# create Sources directory
if [ ! -d "$SOURCES_DIRECTORY" ]; then
  mkdir -p "$SOURCES_DIRECTORY"
else
  # If the Sources directory exists, delete its contents
  rm -r "$SOURCES_DIRECTORY"/*
fi

# copy code to Sources directory
for dir in "${SOURCE_DIRECTORIES[@]}"; do
  cp -r $dir $SOURCES_DIRECTORY
done



# This script recursively searches for files
# and changes all C language #include <> statements to #include "" using regular expressions.
# and rename internal.h to {architecture}_internal.h to fix duplicate definition error.
process_files() {
  local files=("$1"/*)
  
  for file in "${files[@]}"; do
    if [[ -d "$file" ]]; then
      # If it's a directory, recursively process it
      process_files "$file"
    elif [[ -f "$file" ]]; then
      directory_name=$(dirname "$file")
      parent_folder_name=$(basename "$directory_name")

      # If it's a file, use sed command to modify the content

      # changes all C language #include <> statements to #include "" using regular expressions.
      # rename code internal.h to {architecture}_internal.h to fix duplicate definition error.
      sed -i '' -e 's/#include <\(.*\.h\)>/#include "\1"/g' -e "s/#include \"$INTERNAL_HEADER_FILE_NAME\"/#include \"$parent_folder_name\_$INTERNAL_HEADER_FILE_NAME\"/g" "$file"
      echo "Modified file: $file"

      # rename file name from internal.h to {architecture}_internal.h to fix duplicate definition error.
      file_name=$(basename "$file")
      if [[ "$file_name" == $INTERNAL_HEADER_FILE_NAME ]]; then
        mv "$file" "$directory_name/$parent_folder_name"_"$INTERNAL_HEADER_FILE_NAME"
        echo "Renamed file: $file"
      fi
    fi
  done
}
for dir in "${SOURCES_DIRECTORY[@]}"; do
  process_files "$dir"
done



# Merge code
for dir in "${SOURCE_DIRECTORIES[@]}"; do
    rsync -a "$SOURCES_DIRECTORY/$dir/" "$SOURCES_DIRECTORY/"
    rm -r "$SOURCES_DIRECTORY/$dir"
done
echo "Merge completed!"