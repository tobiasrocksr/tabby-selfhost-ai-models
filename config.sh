#!/bin/bash

# Định nghĩa các biến mặc định
export PORT=8080
export DEVICE="metal"  # metal cho Mac M1/M2, cuda cho NVIDIA GPU, cpu cho máy không có GPU
export DATA_DIR="$HOME/.tabby"
# Generate UUID format JWT secret if not already set
if [ -z "$JWT_SECRET" ] || [ "$JWT_SECRET" = "tabby-secure-token-do-not-change" ]; then
    export JWT_SECRET=$(uuidgen)
fi
export CHAT_MODEL="Qwen2-1.5B-Instruct"

# Biến toàn cục khác
export OS="Unknown"
export MAC_CHIP=""
export DISTRO=""
export HAS_GPU=false
export GPU_TYPE="Unknown"
export USE_DOCKER=false

# Hằng số
export CONFIG_FILE="$HOME/.tabby_runner_config"

# Đọc cấu hình từ file nếu tồn tại
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        echo "Đang đọc cấu hình từ $CONFIG_FILE..."
        source "$CONFIG_FILE"
    fi
    
    # Validate UUID format and regenerate if invalid
    if ! [[ $JWT_SECRET =~ ^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$ ]]; then
        export JWT_SECRET=$(uuidgen)
        save_config
    fi
    
    echo "JWT Secret: $JWT_SECRET"
}

# Lưu cấu hình hiện tại vào file
save_config() {
    echo "Đang lưu cấu hình vào $CONFIG_FILE..."
    echo "# Tabby Runner Configuration" > "$CONFIG_FILE"
    echo "# Tự động tạo bởi Tabby Runner" >> "$CONFIG_FILE"
    echo "# $(date)" >> "$CONFIG_FILE"
    echo "" >> "$CONFIG_FILE"
    echo "PORT=$PORT" >> "$CONFIG_FILE"
    echo "DEVICE=$DEVICE" >> "$CONFIG_FILE"
    echo "DATA_DIR=$DATA_DIR" >> "$CONFIG_FILE"
    echo "JWT_SECRET=$JWT_SECRET" >> "$CONFIG_FILE"
    echo "CHAT_MODEL=$CHAT_MODEL" >> "$CONFIG_FILE"
    echo "USE_DOCKER=$USE_DOCKER" >> "$CONFIG_FILE"
    echo "" >> "$CONFIG_FILE"
    echo "Cấu hình đã được lưu!"
}

# Load cấu hình khi khởi động
load_config