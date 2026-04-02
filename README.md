# 音频下载转录工具 (Audio Transcriber)

一个基于 OpenAI Whisper 的自动化音频转录工具。支持通过 URL 多线程下载音频并将其转换为文本。

## 功能特点
- **多线程下载**：支持大文件分片并行下载，显著提高速度。
- **自动转录**：使用 Whisper 模型进行高精度转录。
- **一键安装**：包含 Windows 下的自动化依赖安装脚本。
- **环境隔离**：使用 Python 虚拟环境 (venv)，不污染系统环境。

## 快速开始

### 1. 准备工作
- 确保你的电脑已安装 [Python 3.8+](https://www.python.org/)。
- **关键依赖**：此项目需要 `ffmpeg`。
    - 下载地址：[FFmpeg Builds](https://github.com/BtbN/FFmpeg-Builds/releases)
    - 请将下载后的 `bin` 文件夹路径添加到系统的 **环境变量 PATH** 中。

### 2. 安装依赖
双击运行目录下的 `install.bat`。它会自动：
- 创建虚拟环境。
- 安装 `openai-whisper`, `torch`, `requests`, `tqdm` 等库。

### 3. 运行脚本
安装完成后，直接双击运行 `run.bat`。
- 输入音频文件的直接下载 URL。
- 等待下载和转录完成。

## 注意事项
- 第一次运行转录时，程序会自动从网络下载 Whisper 的 `base` 模型（约 140MB），后续运行将不再下载。
- 如果你的电脑有 NVIDIA 显卡且配置了 CUDA 环境，转录速度会非常快。

## 开源协议
MIT License
