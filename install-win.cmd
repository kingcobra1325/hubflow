@echo off
setlocal

set GIT_HOME=C:\Program Files\Git

if not exist "%GIT_HOME%\bin\git-hf" goto :Install

echo HubFlow is already installed.>&2
set /p mychoice="Do you want to replace it [y/n] "
if "%mychoice%"=="y" goto :DeleteOldFiles
goto :Abort

:DeleteOldFiles
echo Deleting old files...
for /F %%i in ("%GIT_HOME%\git-hf*" "%GIT_HOME%\hubflow-*") do (
    if exist "%%~fi" del /F /Q "%%~fi"
)

:Install
echo Copying files...
::goto :EOF
xcopy "%~dp0\git-hf" "%GIT_HOME%\bin" /Y /R /F
echo "%~dp0\git-hf*"
xcopy "%~dp0\git-hf*" "%GIT_HOME%\bin" /Y /R /F || set ERR=1
xcopy "%~dp0\hubflow-*" "%GIT_HOME%\bin" /Y /R /F || set ERR=1
xcopy "%~dp0\shFlags\src\shflags" "%GIT_HOME%\bin\hubflow-shFlags" /Y /R /F || set ERR=1

set "PATH=%PATH%;%GIT_HOME%\bin"

if %ERR%==1 (
    choice /T 30 /C Y /D Y /M "Some unexpected errors happened. Sorry, you'll have to fix them by yourself."
)

:End
endlocal & exit /B %ERR%

goto :EOF

:AccessDenied
set ERR=1
echo.
echo You should run this script with "Full Administrator" rights:>&2
echo - Right-click with Shift on the script from the Explorer>&2
echo - Select "Run as administrator">&2
choice /T 30 /C YN /D Y /N >nul
goto :End

:Abort
echo Installation canceled.>&2
set ERR=1
goto :End

:ChkGetopt
:: %1 is getopt.exe
if exist "%GIT_HOME%\bin\%1" goto :EOF
if exist "%USERPROFILE%\bin\%1" goto :EOF
if exist "%~f$PATH:1" goto :EOF

echo %GIT_HOME%\bin\%1 not found.>&2
echo You have to install this file manually. See the GitFlow README.
exit /B 1

:FindGitHome
setlocal
set GIT_CMD_DIR=%~dp$PATH:1

if "%GIT_CMD_DIR%"=="" (
    endlocal
    goto :EOF
)

endlocal
set GIT_HOME=%GIT_CMD_DIR:~0,-5%
goto :EOF