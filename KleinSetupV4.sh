#!/bin/bash

# 1. Задаем жесткий путь к папке чекпоинтов. 
# ВНИМАНИЕ: Проверь, чтобы этот путь точно совпадал со структурой твоего Docker-образа на Vast.ai.
DEST_DIR="/workspace/ComfyUI/models"
mkdir -p "$DEST_DIR"

echo "Начинаю загрузку моделей..."

# ==========================================
# 3. ЗАГРУЗКА С HUGGINGFACE
# ==========================================
# Сценарий А: Открытая модель.
# Слепая зона: Ссылка должна вести не на страницу модели, а на сырой файл (resolve/main).
wget --show-progress "https://huggingface.co/wikeeyang/Flux2-Klein-9B-True-V1/resolve/main/Flux2-Klein-9B-True-bf16.safetensors" -O "flux2Klein9BTrue_v10Bf16.safetensors" -P "$DEST_DIR"
wget --show-progress "https://huggingface.co/Ashen3/SNOFS/resolve/main/klein_snofs_v1_1.safetensors" -O "klein_snofs_v1_1.safetensors" -P "$DEST_DIR"
wget --show-progress "https://huggingface.co/Comfy-Org/vae-text-encorder-for-flux-klein-9b/resolve/main/split_files/text_encoders/qwen_3_8b.safetensors" -O "qwen_3_8b.safetensors" -P "$DEST_DIR"
wget --show-progress "https://huggingface.co/Comfy-Org/flux2-dev/resolve/main/split_files/vae/flux2-vae.safetensors" -O "flux2-vae.safetensors" -P "$DEST_DIR"
