#!/bin/bash

# Function kiểm tra và đổi port
check_port() {
    # Kiểm tra xem port có đang được sử dụng không
    if command -v lsof &>/dev/null; then
        if lsof -i :$PORT &>/dev/null; then
            echo "Port $PORT đang được sử dụng bởi một ứng dụng khác."
            echo "Vui lòng chọn port khác."
            echo -n "Nhập port mới: "
            read new_port
            if [[ ! -z "$new_port" ]]; then
                PORT=$new_port
                echo "Đã đổi sang port $PORT"
                save_config
            fi
        else
            echo "Port $PORT khả dụng."
        fi
    fi
}

# Function thay đổi port
change_port() {
    show_header
    echo "ĐỔI PORT"
    echo "-----------------------------------"
    echo "Port hiện tại: $PORT"
    echo ""
    
    echo -n "Nhập port mới: "
    read new_port
    if [[ ! -z "$new_port" ]]; then
        PORT=$new_port
        check_port
        save_config
    fi
    
    echo ""
    echo "Nhấn Enter để quay lại menu chính..."
    read
}