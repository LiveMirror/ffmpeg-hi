@echo off

set PKT_MANAGER="packet-manager\mingw-get.exe"
set MINGWROOT=%CD%\mingw
set MSYSROOT=%CD%\msys
set LAUNCHER="msys-shell.cmd"

echo.
echo +++ DELETE MINGW/MSYS INSTALLATION +++
echo.

IF EXIST %MINGWROOT% rmdir /s /q %MINGWROOT%
mkdir %MINGWROOT%

IF EXIST %MSYSROOT% rmdir /s /q %MSYSROOT%
mkdir %MSYSROOT%

::rmdir /s /q packet-manager\var\cache\mingw-get\packages
del packet-manager\var\lib\mingw-get\data\manifest*
del packet-manager\var\lib\mingw-get\data\sysroot*

echo.
echo +++ UPDATING PACKAGE LIST +++
echo.

%PKT_MANAGER% update

echo.
echo +++ INSTALL MINGW +++
echo.

%PKT_MANAGER% install mingw32-gcc-bin
%PKT_MANAGER% install mingw32-gcc-g++-bin
%PKT_MANAGER% install mingw32-make-bin

:: TODO: copy some mingw32 dll's to the cc1.exe directory to prevent errors

echo.
echo +++ INSTALL MSYS +++
echo.

%PKT_MANAGER% install msys-core-bin
%PKT_MANAGER% install msys-core-ext
%PKT_MANAGER% install msys-coreutils-bin
%PKT_MANAGER% install msys-coreutils-ext
%PKT_MANAGER% install msys-base
%PKT_MANAGER% install msys-bash-bin
%PKT_MANAGER% install msys-gcc-bin
%PKT_MANAGER% install msys-make-bin
%PKT_MANAGER% install msys-grep-bin
%PKT_MANAGER% install msys-sed-bin
%PKT_MANAGER% install msys-gawk-bin
%PKT_MANAGER% install msys-wget-bin
%PKT_MANAGER% install msys-bsdtar-bin
%PKT_MANAGER% install msys-tar-bin
%PKT_MANAGER% install msys-gzip-bin
%PKT_MANAGER% install msys-bzip2-bin
%PKT_MANAGER% install msys-perl-bin
%PKT_MANAGER% install msys-libintl-dll
%PKT_MANAGER% install msys-libgmp-dll

rmdir /s /q %MSYSROOT%\postinstall
del %MSYSROOT%\*.ico
del %MSYSROOT%\*.bat

echo.
echo +++ GENERATE MSYS SHELL STARTUP SCRIPT +++
echo.

echo @echo off> %LAUNCHER%
echo set PATH=%%PATH%%;%%CD%%\mingw\bin;%%CD%%\msys\bin;%%CD%%\msys\local\bin;%%CD%%\packet-manager>> %LAUNCHER%
echo echo Paths Added:>> %LAUNCHER%
echo echo     PATH.='%%CD%%\msys\bin'>> %LAUNCHER%
echo echo     PATH.='%%CD%%\mingw\bin'>> %LAUNCHER%
echo echo     PATH.='%%CD%%\msys\local\bin'>> %LAUNCHER%
echo echo     PATH.='%%CD%%\packet-manager'>> %LAUNCHER%
echo echo %%CD%%\mingw /mingw^> msys\etc\fstab>> %LAUNCHER%
echo echo MinGW Mounted:>> %LAUNCHER%
echo echo     '%%CD%%\mingw' -^^^> '/mingw'>> %LAUNCHER%
echo xcopy /y %%CD%%\source\ffmpeg-build.sh %%CD%%\msys\local\bin\* ^> nul>> %LAUNCHER%
echo echo.>> %LAUNCHER%
echo echo Starting MSYS Shell...>> %LAUNCHER%
echo msys\bin\sh.exe --login>> %LAUNCHER%

echo.
echo Installation complete
echo You can now execute %LAUNCHER% to launch the MSYS environment shell
echo and then type './ffmpeg-build.sh' to start building ffmpeg

pause