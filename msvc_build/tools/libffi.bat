@echo off && call %PATH_MODULES_COMMON%\init.bat %1

set CYGBUILDIR=build
if %ARCH% == x64 (set FFI64=-m64)

if exist %PATH_SRC%\%1\%CYGBUILDIR%\. rmdir /S /Q %PATH_SRC%\%1\%CYGBUILDIR%
call %PATH_BIN_CYGWIN%\bash --login -c '%CYGPATH_MODULES%/%1.sh %CYGPATH_SRC% %1 %NUMBER_OF_PROCESSORS% %AVX:/=-% %CYGBUILDIR% %FFI64%'

for %%D in (libffi-8.pdb .libs\libffi-8.dll) do (xcopy /C /F /Y %PATH_SRC%\%1\%CYGBUILDIR%\%%D %PATH_INSTALL%\bin\*)
xcopy /C /F /Y %PATH_SRC%\%1\%CYGBUILDIR%\.libs\libffi-8.lib %PATH_INSTALL%\lib\*
for %%D in (ffi.h ffitarget.h) do (xcopy /C /F /Y %PATH_SRC%\%1\%CYGBUILDIR%\include\%%D %PATH_INSTALL%\include\*)
call do_php %PATH_UTILS%\sub\version.php %1 %PATH_INSTALL%\bin\libffi-8.dll