@echo off
setlocal enabledelayedexpansion
cls

echo ======================================================
echo           Audio Transcriber - Auto Installer
echo ======================================================
echo.

:: 1. Check Python
echo [1/4] Checking Python environment...
python --version >nul 2>&1
if %errorlevel% neq 0 goto :INSTALL_PYTHON
echo [Status] Python is installed.
goto :CHECK_FFMPEG

:INSTALL_PYTHON
echo [Hint] Python not found. Attempting to install via winget...
winget install -e --id Python.Python.3.10 --accept-package-agreements --accept-source-agreements
if %errorlevel% neq 0 (
    echo [Error] Auto-install failed.
    echo Please install Python 3.10+ manually from https://www.python.org/
    echo NOTE: Make sure to check "Add Python to PATH" during installation!
    pause
    exit /b
)
echo [Success] Python installation started. Restart this script after it finishes.
pause
exit /b

:CHECK_FFMPEG
echo [2/4] Checking ffmpeg (Audio Engine)...
ffmpeg -version >nul 2>&1
if %errorlevel% neq 0 goto :INSTALL_FFMPEG
echo [Status] ffmpeg is ready.
goto :CREATE_VIRTUAL_ENV

:INSTALL_FFMPEG
echo [Hint] ffmpeg not found. Attempting to install...
winget install -e --id Gyan.FFmpeg --accept-package-agreements --accept-source-agreements
if %errorlevel% neq 0 (
    echo [Warning] ffmpeg auto-install failed. 
    echo If the script fails later, please install ffmpeg manually.
) else (
    echo [Success] ffmpeg installed. Please restart the window if still not found.
)
goto :CREATE_VIRTUAL_ENV

:CREATE_VIRTUAL_ENV
echo [3/4] Preparing Python Virtual Environment (venv)...
if exist "venv" (
    echo [Status] venv already exists.
) else (
    python -m venv venv
    if %errorlevel% neq 0 (
        echo [Error] Failed to create venv. Check your Python installation.
        pause
        exit /b
    )
    echo [Success] venv created.
)

:: 4. Install Dependencies
echo [4/4] Downloading required libraries...
echo ------------------------------------------------------
if not exist "requirements.txt" (
    echo [Error] requirements.txt not found!
    pause
    exit /b
)

:: Activate and Update pip (using Tsinghua mirror for speed)
call .\venv\Scripts\activate
python -m pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

if %errorlevel% neq 0 (
    echo.
    echo [Tip] Installation might have partial issues. 
    echo Try closing your VPN/Proxy and run again if it fails.
)

echo.
echo ======================================================
echo [Congrats] All steps completed!
echo.
echo You can now double-click [run.bat] to start.
echo ======================================================
pause
exit /b
