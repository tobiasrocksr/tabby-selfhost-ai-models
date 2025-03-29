#!/bin/bash

# Function phát hiện hệ điều hành
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="Linux"
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            DISTRO=$NAME
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macOS"
        ARCH=$(uname -m)
        if [[ "$ARCH" == "arm64" ]]; then
            MAC_CHIP="Apple Silicon (M1/M2/M3)"
            DEVICE="metal"
        else
            MAC_CHIP="Intel"
            DEVICE="cpu"
        fi
    elif [[ "$OSTYPE" == "cygwin" ]]; then
        OS="Windows (Cygwin)"
    elif [[ "$OSTYPE" == "msys" ]]; then
        OS="Windows (MSYS)"
    elif [[ "$OSTYPE" == "win32" ]]; then
        OS="Windows"
    else
        OS="Unknown"
    fi
}

# Function kiểm tra GPU
check_gpu() {
    HAS_GPU=false
    
    if [[ "$OS" == "macOS" ]]; then
        if [[ "$MAC_CHIP" == "Apple Silicon (M1/M2/M3)" ]]; then
            # Mặc định Apple Silicon có GPU tích hợp có thể sử dụng Metal
            HAS_GPU=true
            GPU_TYPE="Apple Silicon Integrated GPU (Metal)"
        else
            # Mac Intel có thể có GPU rời, nhưng không hỗ trợ Metal
            HAS_GPU=false
            GPU_TYPE="Không hỗ trợ"
        fi
    elif [[ "$OS" == "Linux" || "$OS" == "Windows"* ]]; then
        # Kiểm tra GPU NVIDIA
        if command -v nvidia-smi &>/dev/null; then
            HAS_GPU=true
            GPU_INFO=$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null)
            if [[ ! -z "$GPU_INFO" ]]; then
                GPU_TYPE="NVIDIA: $GPU_INFO"
                DEVICE="cuda"
            else
                HAS_GPU=false
                GPU_TYPE="Không phát hiện NVIDIA GPU"
                DEVICE="cpu"
            fi
        else
            HAS_GPU=false
            GPU_TYPE="Không phát hiện NVIDIA GPU"
            DEVICE="cpu"
        fi
    fi
}

# Function kiểm tra xem Tabby đã được cài đặt chưa
check_tabby_installed() {
    if command -v tabby &>/dev/null; then
        return 0  # Tabby đã được cài đặt
    else
        return 1  # Tabby chưa được cài đặt
    fi
}

# Hiển thị header
show_header() {
    clear
    echo "====================================="
    echo "  TABBY AI CODING ASSISTANT RUNNER"
    echo "====================================="
    echo "Hệ điều hành: $OS"
    if [[ "$OS" == "macOS" ]]; then
        echo "Chip: $MAC_CHIP"
    fi
    echo "GPU: $GPU_TYPE"
    if [[ "$USE_DOCKER" == true ]]; then
        echo "Mode: Docker"
    fi
    echo "Device: $DEVICE | Port: $PORT"
    echo "Data directory: $DATA_DIR"
    echo "JWT Secret: $(echo $JWT_SECRET | cut -c1-5)****"
    echo "====================================="
    echo ""
}