@echo off
setlocal

rem check OS Version
for /f "tokens=4 delims=. " %%n in ('ver') do set VERSION=%%n
if %VERSION% lss 10 (
    echo "This script must run on Windows 10 (minimum)."
    if "%PL2303_NO_INTERACTION%" equ "1" exit /b 1
    pause
    exit /b 1
)

rem check for admin priviledges
fltmc.exe filters >nul 2>&1

if %errorlevel% neq 0 (
    if "%PL2303_NO_INTERACTION%" equ "1" exit /b 1
    goto elevate
) else (
    goto install
)

:elevate
rem create a temp elevation script and run it
echo Set UAC = CreateObject^("Shell.Application"^) > "%TEMP%\elevate.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 10 >> "%TEMP%\elevate.vbs"
"%TEMP%\elevate.vbs"
exit /b

:install
rem remove the temp script if it exists
if exist "%TEMP%\elevate.vbs" del "%TEMP%\elevate.vbs"

rem run the Powershell installer script
set NONINTERACTIVE=
if "%PL2303_NO_INTERACTION%" equ "1" set NONINTERACTIVE=-NonInteractive
set SCRIPT_PATH=pl2303eol\main.ps1
set INSTALLER="%~dp0%SCRIPT_PATH%"
Powershell -NoProfile %NONINTERACTIVE% -ExecutionPolicy Bypass -Command "& "%INSTALLER%""
