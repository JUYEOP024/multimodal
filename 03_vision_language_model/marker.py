import subprocess
import gdown
import os

# =========================
# 1. Google Drive 폴더 다운로드
# =========================

folder_id = "1Cs5k7mFzhsrI-g6qVByyH19BidCUPjG7" # 여기에_폴더ID_입력
drive_url = f"https://drive.google.com/drive/folders/{folder_id}"

download_dir = "./parser"
os.makedirs(download_dir, exist_ok=True)

print("📥 Google Drive 폴더 다운로드 중...")
gdown.download_folder(drive_url, output=download_dir, quiet=False, use_cookies=False)

print("다운로드 완료!")

# =========================
# 2. Marker 배치 실행 (GPU 사용 가능)
# =========================

output_dir = "./output"
os.makedirs(output_dir, exist_ok=True)

print("Marker 배치 병렬 실행 중...")

# GPU가 여유가 있다면 Popen을 사용해 백그라운드에서 병렬로 실행합니다.
proc_json = subprocess.Popen([
    "marker_batch",
    download_dir,
    "--output_format", "json",
    "--output_dir", output_dir,
    "--device", "cuda",
    "--workers", "4"   # 4개의 문서 동시 변환
])

proc_md = subprocess.Popen([
    "marker_batch",
    download_dir,
    "--output_format", "markdown",
    "--output_dir", output_dir,
    "--device", "cuda",
    "--workers", "4"   # 4개의 문서 동시 변환
])


# 두 작업이 완료될 때까지 대기
proc_json.wait()
proc_md.wait()

print("파싱 완료! (병렬 처리)")