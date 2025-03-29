#!/bin/bash

# Function chạy Tabby với model đã chọn
run_tabby() {
    local model=$1
    local chat_model=$2
    local extra_args=$3
    
    clear
    echo "====================================="
    echo "  KHỞI ĐỘNG TABBY AI CODING ASSISTANT"
    echo "====================================="
    echo "Model: $model"
    if [ ! -z "$chat_model" ]; then
        echo "Chat model: $chat_model"
    fi
    echo "Device: $DEVICE | Port: $PORT"
    echo "====================================="
    echo ""
    echo "Đang khởi động Tabby..."
    echo "Nhấn Ctrl+C để dừng Tabby"
    echo ""
    
    # Kiểm tra port trước khi chạy
    check_port
    
    # Thiết lập biến môi trường cho JWT token
    export TABBY_WEBSERVER_JWT_TOKEN_SECRET="$JWT_SECRET"
    
    if [[ "$USE_DOCKER" == true ]]; then
        # Sử dụng Docker
        if [[ "$OS" == "Windows"* ]]; then
            docker_data_path="%USERPROFILE%\\.tabby"
        else
            docker_data_path="$HOME/.tabby"
        fi
        
        if [ ! -z "$chat_model" ]; then
            if [[ "$HAS_GPU" == true && "$DEVICE" != "cpu" ]]; then
                docker run -it -e TABBY_WEBSERVER_JWT_TOKEN_SECRET="$JWT_SECRET" --gpus all -p $PORT:8080 -v $docker_data_path:/data tabbyml/tabby serve --model $model --chat-model $chat_model --device $DEVICE $extra_args
            else
                docker run -it -e TABBY_WEBSERVER_JWT_TOKEN_SECRET="$JWT_SECRET" -p $PORT:8080 -v $docker_data_path:/data tabbyml/tabby serve --model $model --chat-model $chat_model --device cpu $extra_args
            fi
        else
            if [[ "$HAS_GPU" == true && "$DEVICE" != "cpu" ]]; then
                docker run -it -e TABBY_WEBSERVER_JWT_TOKEN_SECRET="$JWT_SECRET" --gpus all -p $PORT:8080 -v $docker_data_path:/data tabbyml/tabby serve --model $model --device $DEVICE $extra_args
            else
                docker run -it -e TABBY_WEBSERVER_JWT_TOKEN_SECRET="$JWT_SECRET" -p $PORT:8080 -v $docker_data_path:/data tabbyml/tabby serve --model $model --device cpu $extra_args
            fi
        fi
    else
        # Sử dụng cài đặt trực tiếp
        if [ ! -z "$chat_model" ]; then
            tabby serve --device $DEVICE --model $model --chat-model $chat_model --port $PORT $extra_args
        else
            tabby serve --device $DEVICE --model $model --port $PORT $extra_args
        fi
    fi
    
    echo ""
    echo "Tabby đã dừng. Nhấn Enter để quay lại menu chính..."
    read
}