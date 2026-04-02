@echo off
setlocal enabledeladedexpansion
chcp 65001 >nul
cls

echo ======================================================
echo           音频下载转录工具 - 环境自动注入器
echo ======================================================

:: 1. 检查 Python
echo [1/4] 正在检查 Python 环境...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [警告] 未检测到 Python！
    echo 正在尝试通过 winget 自动安装 Python 3.10...
    winget install -e --id Python.Python.3.10 --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo [错误] 自动安装失败。
        echo 请手动访问 https://www.python.org/ 下载并安装。
        echo 注意：安装时务必勾选 "Add Python to PATH"！！
        pause
        exit /b
    )
    echo [成功] Python 安装任务已启动，请在安装完成后重新运行本脚本。
    pause
    exit /b
)

:: 2. 检查 ffmpeg (Whisper 核心依赖)
echo [2/4] 正在检查 ffmpeg (音频处理引擎)...
ffmpeg -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [提示] 未检测到 ffmpeg，正在尝试自动安装...
    winget install -e --id Gyan.FFmpeg --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo [警告] ffmpeg 自动安装失败。这通常是因为权限或 winget 版本问题。
        echo 请稍后手动安装 ffmpeg，否则脚本将无法提取音频。
    ) else (
        echo [成功] ffmpeg 已尝试安装。如果仍提示找不到，请重新打开此窗口。
    )
) else (
    echo [状态] ffmpeg 已就绪。
)

:: 3. 创建虚拟环境
echo [3/4] 正在创建隔离的 Python 运行环境 (venv)...
if not exist "venv" (
    python -m venv venv
)

:: 4. 安装依赖库
echo [4/4] 正在连接服务器下载依赖库 (这取决于你的网速)...
echo ------------------------------------------------------
call .\venv\Scripts\activate
python -m pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

echo.
echo ======================================================
echo [恭喜] 安装所有步骤已尝试完成！
echo.
echo 如果没报错，现在你可以双击 [run.bat] 开始使用了。
echo ======================================================
pause
