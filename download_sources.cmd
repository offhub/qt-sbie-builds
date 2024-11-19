echo %*
set "qt_version=%2"
if "%qt_version:~4,1%" == "." (set "qt_version_nomin=%qt_version:~0,4%") else ("qt_version_nomin=%qt_version:~0,5%")
set "qt_source_url=https://download.qt.io/archive/qt/%qt_version_nomin%/%qt_version%/single/qt-everywhere-src-%qt_version%.zip"
set "qt_patch_url=https://download.qt.io/archive/qt/%qt_version_nomin%"
set "openssl_version=%3"
set "openssl_source_url=https://github.com/openssl/openssl/releases/download/openssl-%openssl_version%/openssl-%openssl_version%.tar.gz"
set "bDir=%~dp0"
set "bDir=%bDir:~0,-1%"
set "EOL=CRLF"
if "%EOL%" == "LF" (
    echo Patch file line endings will be converted to LF ^(Unix^) using Dos2Unix.
    set "EOLconverter=dos2unix"
) else (
    echo Patch file line endings will be converted to CRLF ^(Windows^) using Unix2Dos.
    set "EOLconverter=unix2dos"
)

if exist "%bDir%\qt-everywhere-src-%qt_version%\configure.bat" goto done

REM Downloading Qt 6.8 source code...
echo Downloading Qt %qt_version% source code...
curl -LsSO --output-dir "%bDir%" "%qt_source_url%"
"C:\Program Files\7-Zip\7z.exe" x -aoa -o"%bDir%" "%bDir%\qt-everywhere-src-%qt_version%.zip"
move "%bDir%\qt-everywhere-src-%qt_version%" "%bDir%\src"

REM Downloading Qt 6.8 security patches...
echo Downloading Qt %qt_version% security patches...

if "%qt_version%" == "6.8.0" echo Qt version is %qt_version% & goto verMin0
if "%qt_version%" == "6.8.1" echo Qt version is %qt_version% & goto verMin1
if "%qt_version%" == "6.8.2" echo Qt version is %qt_version% & goto verMin2
if "%qt_version%" == "6.8.3" echo Qt version is %qt_version% & goto verMin3
if "%qt_version%" == "6.8.4" echo Qt version is %qt_version% & goto verMin4
if "%qt_version%" == "6.8.5" echo Qt version is %qt_version% & goto verMin5
if "%qt_version%" == "6.8.6" echo Qt version is %qt_version% & goto verMin6

:verMin0
REM curl -LsSO --output-dir "%bDir%\src\qtsvg" "%qt_patch_url%/CVE-2023-32573-qtsvg-5.15.diff"
:verMin1
:verMin2
:verMin3
:verMin4
:verMin5
:verMin6


REM Install GNU Patch tool (from Chocolatey)...
choco install patch -y

REM Install Dos2Unix / Unix2Dos - Text file format converters
choco install dos2unix -y

REM Patch Qt sources...
REM pushd "%bDir%\src\qtsvg"
REM set qtsvg_patches="CVE-2023-32573-qtsvg-5.15.diff"
REM for %%i in (%qtsvg_patches%) do (
    REM if exist "%%i" (
        REM echo Applying patch "%%i"
        REM %EOLconverter% --verbose "%%i"
        REM patch -p1 --verbose -u -i "%%i"
    REM ) else (
        REM echo File "%%i" does not exist. Skipping...
    REM )
REM )
REM popd

REM pushd "%bDir%\src\qtbase"
REM set qtbase_patches="CVE-2023-32762-qtbase-5.15.diff" "CVE-2023-33285-qtbase-5.15.diff" "CVE-2023-32763-qtbase-5.15.diff" "CVE-2023-34410-qtbase-5.15.diff" "CVE-2023-37369-qtbase-5.15.diff" "CVE-2023-38197-qtbase-5.15.diff" "CVE-2023-43114-5.15.patch" "0001-CVE-2023-51714-qtbase-5.15.diff" "0002-CVE-2023-51714-qtbase-5.15.diff" "CVE-2024-25580-qtbase-5.15.diff" "CVE-2024-39936-qtbase-5.15.patch"
REM for %%i in (%qtbase_patches%) do (
    REM if exist "%%i" (
        REM echo Applying patch "%%i"
        REM %EOLconverter% --verbose "%%i"
        REM patch -p1 --verbose -u -i "%%i"
    REM ) else (
        REM echo File "%%i" does not exist. Skipping...
    REM )
REM )
REM popd

REM pushd "%bDir%\src\qtimageformats"
REM set qtimageformats_patches="CVE-2023-4863-5.15.patch"
REM for %%i in (%qtimageformats_patches%) do (
    REM if exist "%%i" (
        REM echo Applying patch "%%i"
        REM %EOLconverter% --verbose "%%i"
        REM patch -p1 --verbose -u -i "%%i"
    REM ) else (
        REM echo File "%%i" does not exist. Skipping...
    REM )
REM )
REM popd

REM pushd "%bDir%\src\qtnetworkauth"
REM set qtnetworkauth_patches="CVE-2024-36048-qtnetworkauth-5.15.diff"
REM for %%i in (%qtnetworkauth_patches%) do (
    REM if exist "%%i" (
        REM echo Applying patch "%%i"
        REM %EOLconverter% --verbose "%%i"
        REM patch -p1 --verbose -u -i "%%i"
    REM ) else (
        REM echo File "%%i" does not exist. Skipping...
    REM )
REM )
REM popd

REM Download openssl sources...
curl -LsSO --output-dir "%bDir%" "%openssl_source_url%"
tar -xzf "openssl-%openssl_version%.tar.gz"
move "%bDir%\openssl-%openssl_version%" "%bDir%\src\openssl"

if "%1" == "repack" (
    REM Pack patched Qt sources...
    mkdir "%bDir%\src_archive" && tar -cf "src_archive/qt-everywhere-src-%qt_version%-patched-openssl.tar" "%bDir%\src"
)

:done

REM dir %bDir%
REM dir %bDir%\src
