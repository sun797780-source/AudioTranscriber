@echo off
chcp 65001 >nul
cls

echo ======================================================
echo           音频下载转录工具 - 正在启动...
echo ======================================================

:: 再次检查环境完整性
if not exist ".\venv\Scripts\activate.bat" (
    echo [错误] 环境不完整。请先运行 [install.bat]！
    pause
    exit /b
)

:: 检查 ffmpeg 是否已在 PATH 中
ffmpeg -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [致命错误] 找不到音频处理引擎 ffmpeg。
    echo 请确保：
    echo 1. 已运行 install.bat 尝试自动安装
    echo 2. 如果自动安装失败，请手动安装 ffmpeg 并加入系统 PATH
    pause
    exit /b
)

:: 进入虚拟环境并运行
echo 正在运行脚本...
call .\venv\Scripts\activate
python transcribe_audio.py

echo.
echo ======================================================
echo 转录任务完成。
echo ======================================================
pause
