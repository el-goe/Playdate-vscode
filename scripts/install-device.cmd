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
set "PDX_PATH=%~dp0..\%GAME_PDX%"

if not exist "%PDUTIL%" (
    echo ERROR: pdutil.exe not found:
    echo   %PDUTIL%
    exit /b 1
)

if not exist "%PDX_PATH%" (
    echo ERROR: Device PDX not found:
    echo   %PDX_PATH%
    exit /b 1
)

echo Installing "%GAME_PDX%"...

"%PDUTIL%" install "%PDX_PATH%"

if errorlevel 1 (
    echo.
    echo ERROR: Failed to install the device game.
    exit /b %errorlevel%
)

exit /b 0