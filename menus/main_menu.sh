#!/bin/bash

# Function thiết lập tùy chọn
configure_settings() {
    show_header
    echo "THIẾT LẬP TÙY CHỌN"
    echo "-----------------------------------"
    echo ""
    
    # Thiết lập port
    echo -n "Port để chạy Tabby [mặc định: $PORT]: "
    read new_port
    if [[ ! -z "$new_port" ]]; then
        PORT=$new_port
    fi
    
    # Thiết lập device
    if [[ "$OS" == "macOS" && "$MAC_CHIP" == "Apple Silicon (M1/M2/M3)" ]]; then
        echo "Apple Silicon được phát hiện, thiết bị Metal được khuyến nghị."
        echo -n "Device (metal/cpu) [mặc định: $DEVICE]: "
    elif [[ "$OS" == "macOS" && "$MAC_CHIP" == "Intel" ]]; then
        echo "Mac Intel được phát hiện, thiết bị CPU được khuyến nghị."
        echo -n "Device (cpu) [mặc định: $DEVICE]: "
    else
        echo -n "Device (cuda/cpu) [mặc định: $DEVICE]: "
    fi
    read new_device
    if [[ ! -z "$new_device" ]]; then
        DEVICE=$new_device
    fi
    
    # Thiết lập data directory
    echo -n "Thư mục data [mặc định: $DATA_DIR]: "
    read new_data_dir
    if [[ ! -z "$new_data_dir" ]]; then
        DATA_DIR=$new_data_dir
    fi
    
    # Thiết lập JWT secret
    echo -n "JWT Secret [mặc định: $JWT_SECRET]: "
    read new_jwt_secret
    if [[ ! -z "$new_jwt_secret" ]]; then
        JWT_SECRET=$new_jwt_secret
    fi
    
    # Lưu cấu hình
    save_config
    
    echo ""
    echo "Thiết lập đã được lưu!"
    echo "Nhấn Enter để quay lại menu chính..."
    read
}

# Function hiển thị menu chính
show_main_menu() {
    show_header
    echo "MENU CHÍNH"
    echo "-----------------------------------"
    echo "1) Model cho máy có GPU mạnh (16GB+ VRAM)"
    echo "2) Model cho máy có GPU thông thường"
    echo "3) Model cho máy không có GPU (CPU)"
    echo "4) Model dành riêng cho MacBook Pro"
    echo "5) Đổi chat model (hiện tại: $CHAT_MODEL)"
    echo "6) Thiết lập tùy chọn"
    echo "7) Đổi port (hiện tại: $PORT)"
    echo "8) Thoát"
    echo ""
    echo -n "Nhập lựa chọn của bạn [1-8]: "
}