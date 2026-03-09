#!/bin/bash

# 5. Установка нод
cd custom_nodes
REPOS=(
  "https://github.com/ltdrdata/ComfyUI-Manager.git"
  "https://github.com/city96/ComfyUI-GGUF.git"
  "https://github.com/rgthree/rgthree-comfy.git"
  "https://github.com/yolain/ComfyUI-Easy-Use.git"
  "https://github.com/kijai/ComfyUI-KJNodes.git"
  "https://github.com/cubiq/ComfyUI_essentials.git"
  "https://github.com/wallish77/wlsh_nodes.git"
  "https://github.com/vrgamegirl19/comfyui-vrgamedevgirl.git"
  "https://github.com/ClownsharkBatwing/RES4LYF.git"
  "https://github.com/Jonseed/ComfyUI-Detail-Daemon.git"
  "https://github.com/Fannovel16/comfyui_controlnet_aux.git"
  "https://github.com/chflame163/ComfyUI_LayerStyle.git"
)

for repo in "${REPOS[@]}"; do
  git clone "$repo"
done
cd ..

# 6. Установка зависимостей нод
for d in custom_nodes/*/ ; do
    if [ -f "$d/requirements.txt" ]; then
        pip install -r "$d/requirements.txt" || echo "Ошибка установки зависимостей в $d, продолжаем..."
    fi
done

# 7. Загрузка моделей (Здесь жестко задан Q8_0. Если нужен другой, измени переменную)
MODEL_VERSION="Q8_0"
HF_BASE="https://huggingface.co/Aitrepreneur/FLX/resolve/main"

mkdir -p models/text_encoders models/vae models/loras models/unet models/diffusion_models models/upscale_models

curl -L -o "models/text_encoders/qwen_3_8b_fp8mixed_abliterated.safetensors" "$HF_BASE/qwen_3_8b_fp8mixed_abliterated.safetensors?download=true"
curl -L -o "models/vae/flux2-vae.safetensors" "$HF_BASE/flux2-vae.safetensors?download=true"

# Лоры
LORAS=("KLEIN-DETAILER.safetensors" "detail_slider_klein_9b_20260123_065513.safetensors" "uncrop_F2K9B.safetensors" "anime2real-semi.safetensors" "darkBeastFeb1826Latest_dbkBlitzV15.safetensors" "lenovo_flux_klein9b.safetensors" "nicegirls_flux_klein9b.safetensors")
for lora in "${LORAS[@]}"; do
  curl -L -o "models/loras/$lora" "$HF_BASE/$lora?download=true"
done

# UNET и диффузионка
curl -L -o "models/unet/flux-2-klein-9b-${MODEL_VERSION}.gguf" "$HF_BASE/flux-2-klein-9b-${MODEL_VERSION}.gguf?download=true"
curl -L -o "models/diffusion_models/flux-2-klein-9b-fp8.safetensors" "$HF_BASE/flux-2-klein-9b-fp8.safetensors?download=true"

# Апскейлеры
curl -L -o "models/upscale_models/4x-ClearRealityV1.pth" "$HF_BASE/4x-ClearRealityV1.pth?download=true"
curl -L -o "models/upscale_models/RealESRGAN_x4plus_anime_6B.pth" "$HF_BASE/RealESRGAN_x4plus_anime_6B.pth?download=true"


echo "Установка завершена. Запусти сервер командой: python main.py --listen 0.0.0.0 --port 8188"
