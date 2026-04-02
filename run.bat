@echo off
cls

echo ======================================================
echo           Audio Transcriber - Starting...
echo ======================================================
echo.

:: 1. Check Virtual Env
if exist ".\venv\Scripts\activate.bat" goto :CHECK_FFMPEG
echo [Error] venv not found. Please run [install.bat] first!
pause
exit /b

:CHECK_FFMPEG
:: 2. Check ffmpeg
ffmpeg -version >nul 2>&1
if %errorlevel% equ 0 goto :RUN_APP
echo [Fatal Error] ffmpeg not found.
echo Please run install.bat or install ffmpeg manually and add to PATH.
pause
exit /b

:RUN_APP
:: 3. Run
echo [Status] Starting transcription script...
echo ------------------------------------------------------
call .\venv\Scripts\activate
python transcribe_audio.py

echo.
echo ======================================================
echo Task Finished.
echo ======================================================
pause
exit /b
