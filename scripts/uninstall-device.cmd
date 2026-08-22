@echo off
setlocal EnableDelayedExpansion

if "%~1"=="" (
    echo ERROR: No Playdate game name was provided.
    exit /b 1
)

set "GAME_NAME=%~1"
set "GAME_PDX=%GAME_NAME%_DEVICE.pdx"

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

set "PDUTIL_OUTPUT=%TEMP%\playdate-datadisk-%RANDOM%.txt"

echo Mounting Playdate data disk...

"%PDUTIL%" datadisk > "%PDUTIL_OUTPUT%" 2>&1

if errorlevel 1 (
    type "%PDUTIL_OUTPUT%"
    del /q "%PDUTIL_OUTPUT%" >nul 2>&1
    echo.
    echo ERROR: Failed to mount Playdate data disk.
    exit /b 1
)

type "%PDUTIL_OUTPUT%"

set "PLAYDATE_DRIVE="

for /f "tokens=6" %%d in ('findstr /i /c:"Playdate data disk mounted as" "%PDUTIL_OUTPUT%"') do (
    set "PLAYDATE_DRIVE=%%d"
)

del /q "%PDUTIL_OUTPUT%" >nul 2>&1

if not defined PLAYDATE_DRIVE (
    echo.
    echo ERROR: Could not determine the Playdate data disk drive.
    exit /b 1
)

set "PLAYDATE_DRIVE=!PLAYDATE_DRIVE:~0,2!"
set "GAME_PATH=!PLAYDATE_DRIVE!\Games\!GAME_PDX!"

echo.
echo Playdate mounted as !PLAYDATE_DRIVE!
echo.

echo Looking for:
echo   !GAME_PATH!

if not exist "!GAME_PATH!\" (
    echo.
    echo Game not found. Nothing to remove.
    goto :finish
)

echo Removing:
echo   !GAME_PATH!

rmdir /s /q "!GAME_PATH!"

if errorlevel 1 (
    echo.
    echo ERROR: Windows reported that the PDX could not be removed.
    echo Make sure the game is not currently running.
    exit /b 1
)

if exist "!GAME_PATH!\" (
    echo.
    echo ERROR: The PDX still exists after the removal operation:
    echo   !GAME_PATH!
    exit /b 1
)

echo.
echo Successfully removed !GAME_PDX!.

:finish

echo.
echo ============================================================
echo  Press A on the Playdate to exit Data Disk mode.
echo ============================================================
echo.

pause

exit /b 0