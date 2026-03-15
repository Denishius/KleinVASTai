#!/bin/bash

if [ -z "$CIVITAI_TOKEN" ]; then
    echo "КРИТИЧЕСКАЯ ОШИБКА: Переменная CIVITAI_TOKEN не задана."
    exit 1
fi

# 1. Защита от дурака: ставим утилиту. На Vast.ai скрипты выполняются от root, поэтому sudo не нужен.
apt-get update && apt-get install -y aria2c

# 2. Определяем директорию. Снова напоминаю: убедись, что путь актуален для твоего образа.
DEST_DIR="/workspace/ComfyUI/models/checkpoints"
mkdir -p "$DEST_DIR"

# 3. Переменная с аргументами для максимальной скорости: 
# -x 16 (максимум соединений на сервер)
# -s 16 (делить файл на 16 частей)
# -k 1M (минимальный размер куска)
# -c (продолжить загрузку при обрыве)
# -d (директория назначения)
ARIA_OPT="-x 16 -s 16 -k 1M -c -d $DEST_DIR"

echo "Запускаю многопоточную загрузку aria2c..."

# ==========================================
# ЗАГРУЗКА С CIVITAI
# ==========================================
# Обязательно задавай правильное имя файла через -o "имя.safetensors", иначе ComfyUI его не прочитает.
aria2c $ARIA_OPT -o "flux2Klein9BTrue_v10Bf16.safetensors" "https://civitai.com/api/download/models/2631758?type=Model&format=SafeTensor&size=pruned&fp=bf16?token=${CIVITAI_TOKEN}"
aria2c $ARIA_OPT -o "klein_snofs_v1_2.safetensors"
"https://civitai.com/api/download/models/2771019?type=Model&format=SafeTensor?token=${CIVITAI_TOKEN}"

# ==========================================
# ЗАГРУЗКА С HUGGINGFACE (Открытая модель)
# ==========================================
aria2c $ARIA_OPT -o "qwen_3_8b.safetensors"
"https://huggingface.co/Comfy-Org/vae-text-encorder-for-flux-klein-9b/resolve/main/split_files/text_encoders/qwen_3_8b.safetensors?download=true"
aria2c $ARIA_OPT -o "flux2-vae.safetensors"
"https://huggingface.co/Comfy-Org/flux2-dev/resolve/main/split_files/vae/flux2-vae.safetensors?download=true"

# ==========================================
# ЗАГРУЗКА С HUGGINGFACE (Закрытая модель)
# ==========================================
# Токен передается в заголовке, имя файла так же фиксируем жестко.
#aria2c $ARIA_OPT --header="Authorization: Bearer ТВОЙ_HF_TOKEN" -o #"hf_closed_model.safetensors" #"https://huggingface.co/ИМЯ_АВТОРА/ИМЯ_МОДЕЛИ/resolve/main/имя_файла.safetensors"

echo "Инициализация и загрузка моделей завершены."