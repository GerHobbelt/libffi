#call %PATH_BIN_CYGWIN%\bash --login -c '%CYGPATH_MODULES%/%1.sh %CYGPATH_SRC% %1 %NUMBER_OF_PROCESSORS% %AVX:/=-% %CYGBUILDIR% %FFI64%'
cd $1/$2
PDB=libffi-8.pdb
./configure --enable-builddir=$5 CC="/cygdrive/c/sdk/src/$2/msvcc.sh $6" CXX="/cygdrive/c/sdk/src/$2/msvcc.sh $ARCH_PRF" LD="link -DEBUG -NOLOGO -LTCG -OPT:REF,ICF -PDB:link.pdb" CPP="cl -nologo -EP" CPPFLAGS="-DFFI_BUILDING_DLL" CFLAGS="-DWIN32 -D_WINDOWS -MD -Zi -O2 -GL -MD -MP$3 $4 -DNDEBUG -Fdlibffi-8 -FS"
# -Fd$PDB /FS
rm -f ./$4/$PDB
make