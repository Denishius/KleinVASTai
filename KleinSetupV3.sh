#!/bin/bash

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
aria2c $ARIA_OPT -o "my_civitai_model.safetensors" "https://civitai.com/api/download/models/2631758?type=Model&format=SafeTensor&size=pruned&fp=bf16?token=1ae11039b9ff1dc649d59d394659d843"
"https://civitai.com/api/download/models/2771019?type=Model&format=SafeTensor?token=1ae11039b9ff1dc649d59d394659d843"

# ==========================================
# ЗАГРУЗКА С HUGGINGFACE (Открытая модель)
# ==========================================
aria2c $ARIA_OPT -o "hf_open_model.safetensors" 
"https://huggingface.co/Comfy-Org/vae-text-encorder-for-flux-klein-9b/tree/main/split_files/text_encoders"
"https://huggingface.co/Comfy-Org/flux2-dev/tree/main/split_files/vae"

# ==========================================
# ЗАГРУЗКА С HUGGINGFACE (Закрытая модель)
# ==========================================
# Токен передается в заголовке, имя файла так же фиксируем жестко.
#aria2c $ARIA_OPT --header="Authorization: Bearer ТВОЙ_HF_TOKEN" -o #"hf_closed_model.safetensors" #"https://huggingface.co/ИМЯ_АВТОРА/ИМЯ_МОДЕЛИ/resolve/main/имя_файла.safetensors"

echo "Инициализация и загрузка моделей завершены."