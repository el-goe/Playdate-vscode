@echo off
setlocal

if "%~1"=="" (
    echo ERROR: No Playdate game name was provided.
    exit /b 1
)

set "GAME_NAME=%~1"
set "GAME_PDX=%GAME_NAME%_DEVICE.pdx"

call "%~dp0playdate-config.cmd"

if "%PLAYDATE_SDK_PATH%"=="" (
    echo ERROR: PLAYDATE_SDK_PATH is not set.
    exit /b 1
)

set "PDUTIL=%PLAYDATE_SDK_PATH%\bin\pdutil.exe"

if not exist "%PDUTIL%" (
    echo ERROR: pdutil.exe not found:
    echo   %PDUTIL%
    exit /b 1
)

echo Running "%GAME_PDX%" on Playdate...

"%PDUTIL%" run "/Games/%GAME_PDX%"

if errorlevel 1 (
    echo.
    echo ERROR: Failed to run the device game.
    exit /b %errorlevel%
)

exit /b 0