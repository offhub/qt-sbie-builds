echo %*
set "qt_version=%2"
set "bDir=%~dp0"
set "bDir=%bDir:~0,-1%"

set

dir "%bDir%" || echo fail 1
dir "%bDir%\bin" || echo fail 2
dir "%bDir%\jom" || echo fail 3
dir "%bDir%\src" || echo fail 4
dir "%bDir%\src\gnuwin32\bin" || echo fail 5
dir "%bDir%\src\openssl" || echo fail 6
dir "%bDir%\src\qtbase\bin" || echo fail 7
dir "C:\Program Files (x86)\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\" || echo fail 8

if "%1" == "x64" (
    set "build_arch=x64"
    set "PATH=%bDir%\src\qtbase\bin;%bDir%\src\gnuwin32\bin;%bDir%\jom;%PATH%"
    call "C:\Program Files (x86)\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
    pushd "%bDir%\src\openssl"
    perl Configure shared no-asm --prefix=%bDir%\openssl-win64 VC-WIN64A
    nmake
    nmake install
    popd
    pushd "%bDir%\src"
    call configure.bat -release -opensource -confirm-license -prefix "%bDir%\bin\%qt_version%\msvc2022_64" -platform win32-msvc -openssl-linked -nomake tests -nomake examples -skip qtdoc -skip qtwebengine -- -D OPENSSL_ROOT_DIR="%bDir%\openssl-win64"
    rem jom
    rem if %ERRORLEVEL% == 0 jom install
    cmake --build . --parallel
    if %ERRORLEVEL% == 0 cmake --install .
    if %ERRORLEVEL% == 0 mkdir "%bDir%\archive" && "C:\Program Files\7-Zip\7z.exe" a -t7z -mx=9 -mfb=273 -ms -md=31 -myx=9 -mtm=- -mmt -mmtf -md=1536m -mmf=bt3 -mmc=10000 -mpb=0 -mlc=0 "%bDir%\archive\qt-everywhere-%qt_version%-Windows_10-MSVC2022-x86_64.7z" "%bDir%\bin\%qt_version%"
)

if "%1" == "Win32" (
    set "build_arch=x86"
    set "PATH=%bDir%\src\qtbase\bin;%bDir%\src\gnuwin32\bin;%bDir%\jom;%PATH%"
    call "C:\Program Files (x86)\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsamd64_x86.bat"
    pushd "%bDir%\src\openssl"
    perl Configure shared no-asm --prefix="%bDir%\openssl-win32" VC-WIN32
    nmake
    nmake install
    popd
    pushd "%bDir%\src"
    call configure.bat -release -opensource -confirm-license -prefix "%bDir%\bin\%qt_version%\msvc2022" -platform win32-msvc -openssl-linked -nomake tests -nomake examples -skip qtdoc -skip qtwebengine -- -D OPENSSL_ROOT_DIR="%bDir%\openssl-win32"
    rem jom
    rem if %ERRORLEVEL% == 0 jom install
    cmake --build . --parallel
    if %ERRORLEVEL% == 0 cmake --install .
    if %ERRORLEVEL% == 0 mkdir "%bDir%\archive" && "C:\Program Files\7-Zip\7z.exe" a -t7z -mx=9 -mfb=273 -ms -md=31 -myx=9 -mtm=- -mmt -mmtf -md=1536m -mmf=bt3 -mmc=10000 -mpb=0 -mlc=0 "%bDir%\archive\qt-everywhere-%qt_version%-Windows_10-MSVC2022-x86.7z" "%bDir%\bin\%qt_version%"
)

dir "%bDir%" || echo fail 1
dir "%bDir%\bin" || echo fail 2
dir "%bDir%\jom" || echo fail 3
dir "%bDir%\src" || echo fail 4
dir "%bDir%\src\gnuwin32\bin" || echo fail 5
dir "%bDir%\src\openssl" || echo fail 6
dir "%bDir%\src\qtbase\bin" || echo fail 7
dir "C:\Program Files (x86)\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\" || echo fail 8
