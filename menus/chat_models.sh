#!/bin/bash

# Function hiển thị menu chat model
show_chat_models_menu() {
    show_header
    echo "CHỌN CHAT MODEL"
    echo "-----------------------------------"
    echo "1) Qwen2-1.5B-Instruct (mặc định, nhẹ)"
    echo "2) Mistral-7B-Instruct-v0.2 (yêu cầu GPU mạnh)"
    echo "3) Không sử dụng chat model"
    echo "4) Quay lại menu chính"
    echo ""
    echo -n "Nhập lựa chọn của bạn [1-4]: "
    
    read chat_choice
    case $chat_choice in
        1)
            show_model_info "Qwen2-1.5B-Instruct"
            CHAT_MODEL="Qwen2-1.5B-Instruct"
            echo "Đã chọn chat model: $CHAT_MODEL"
            save_config
            sleep 2
            ;;
        2)
            show_model_info "Mistral-7B-Instruct-v0.2"
            CHAT_MODEL="Mistral-7B-Instruct-v0.2"
            echo "Đã chọn chat model: $CHAT_MODEL"
            save_config
            sleep 2
            ;;
        3)
            CHAT_MODEL=""
            echo "Không sử dụng chat model"
            save_config
            sleep 2
            ;;
        4)
            return
            ;;
        *)
            echo "Lựa chọn không hợp lệ. Vui lòng thử lại."
            sleep 2
            show_chat_models_menu
            ;;
    esac
}