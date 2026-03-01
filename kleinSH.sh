#!/bin/bash

# Устанавливаем пути
COMFY_DIR="/workspace/ComfyUI"
NODES_DIR="$COMFY_DIR/custom_nodes"

echo "=== Старт установки окружения для Flux 2 Klein ==="

# 1. Клонирование кастомных нод
echo "-> Клонирование репозиториев..."
cd $NODES_DIR

git clone https://github.com/ltdrdata/ComfyUI-Manager.git
git clone https://github.com/city96/ComfyUI-GGUF.git
git clone https://github.com/rgthree/rgthree-comfy.git
git clone https://github.com/yolain/ComfyUI-Easy-Use.git
git clone https://github.com/kijai/ComfyUI-KJNodes.git
git clone https://github.com/cubiq/ComfyUI_essentials.git
git clone https://github.com/wallish77/wlsh_nodes.git
git clone https://github.com/vrgamegirl19/comfyui-vrgamedevgirl.git
git clone https://github.com/ClownsharkBatwing/RES4LYF.git
git clone https://github.com/Jonseed/ComfyUI-Detail-Daemon.git
git clone https://github.com/Fannovel16/comfyui_controlnet_aux.git
git clone https://github.com/chflame163/ComfyUI_LayerStyle.git

# 2. Установка зависимостей
echo "-> Установка зависимостей (pip)..."
# Ищем все файлы requirements.txt в папках скачанных нод и ставим их
for d in */ ; do
    if [ -f "$d/requirements.txt" ]; then
        echo "Установка зависимостей для $d..."
        pip install -r "$d/requirements.txt"
    fi
done

# Дополнительные зависимости из твоего гайда
pip install gguf piexif google-generativeai google-ai-generativelanguage librosa

# 3. Скачивание моделей напрямую с Hugging Face
echo "-> Скачивание весов моделей..."

# Text Encoder
wget -q --show-progress -O $COMFY_DIR/models/text_encoders/qwen_3_8b_fp8mixed_abliterated.safetensors https://huggingface.co/Aitrepreneur/FLX/resolve/main/qwen_3_8b_fp8mixed_abliterated.safetensors

# VAE
wget -q --show-progress -O $COMFY_DIR/models/vae/flux2-vae.safetensors https://huggingface.co/Aitrepreneur/FLX/resolve/main/flux2-vae.safetensors

# Diffusion Model (FP8)
wget -q --show-progress -O $COMFY_DIR/models/diffusion_models/flux-2-klein-9b-fp8.safetensors https://huggingface.co/Aitrepreneur/FLX/resolve/main/flux-2-klein-9b-fp8.safetensors

# UNet GGUF
# ВНИМАНИЕ: Здесь нужно выбрать квантизацию.
# Так как я не знаю, какую видеокарту ты собираешься арендовать, я прописал Q8_0 по умолчанию.
# Если берешь слабую карту на 12-16 GB, измени значение переменной QUANT на "Q4_K_S" или "Q5_K_S".
QUANT="Q8_0"
wget -q --show-progress -O $COMFY_DIR/models/unet/flux-2-klein-9b-${QUANT}.gguf https://huggingface.co/Aitrepreneur/FLX/resolve/main/flux-2-klein-9b-${QUANT}.gguf

echo "=== Установка завершена. Можно запускать ComfyUI. ==="