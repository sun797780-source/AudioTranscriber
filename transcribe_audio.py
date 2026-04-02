import whisper
import torch
import requests
import tempfile
import os
import sys
from tqdm import tqdm
from concurrent.futures import ThreadPoolExecutor

# 强制使用 UTF-8 输出，防止 Windows 终端乱码
if sys.platform.startswith('win'):
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf8')

print("CUDA available:", torch.cuda.is_available())

model = whisper.load_model("base")

url = input("请输入音频URL: ").strip()

# 下载函数（分片）
def download_chunk(url, start, end):
    headers = {"Range": f"bytes={start}-{end}"}
    response = requests.get(url, headers=headers)
    return start, response.content

tmp_path = None
try:
    # 获取文件大小
    head = requests.head(url)
    file_size = int(head.headers.get("Content-Length", 0))

    # 如果服务器不支持分片，fallback
    if "bytes" not in head.headers.get("Accept-Ranges", ""):
        print("服务器不支持多线程下载，使用单线程...")
        response = requests.get(url)
        data = response.content
    else:
        print(f"文件大小: {file_size / 1024 / 1024:.2f} MB")

        num_threads = 4
        chunk_size = file_size // num_threads

        results = [None] * num_threads

        with ThreadPoolExecutor(max_workers=num_threads) as executor:
            futures = []
            for i in range(num_threads):
                start = i * chunk_size
                end = file_size - 1 if i == num_threads - 1 else (start + chunk_size - 1)
                futures.append(executor.submit(download_chunk, url, start, end))

            with tqdm(total=file_size, unit='B', unit_scale=True, desc="多线程下载") as pbar:
                for future in futures:
                    start, content = future.result()
                    results[start // chunk_size] = content
                    pbar.update(len(content))

        data = b"".join(results)

    # 写入临时文件，关闭句柄后再给 ffmpeg 用
    tmp_fd, tmp_path = tempfile.mkstemp(suffix=".wav")
    with os.fdopen(tmp_fd, "wb") as f:
        f.write(data)

    print("下载完成，开始转录...")
    result = model.transcribe(tmp_path)

    print("\n转录结果：")
    print(result["text"])

except Exception as e:
    print("出错了：", e)

finally:
    if tmp_path and os.path.exists(tmp_path):
        try:
            os.unlink(tmp_path)
        except:
            pass
