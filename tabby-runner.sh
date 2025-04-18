#!/bin/bash

# Tabby Runner - Script chính
# Set script_dir để có thể tìm các module
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Đảm bảo thư mục tồn tại
mkdir -p "$SCRIPT_DIR/utils" "$SCRIPT_DIR/menus" "$SCRIPT_DIR/models"

# Load config
source "$SCRIPT_DIR/config.sh"

# Load các module utils
source "$SCRIPT_DIR/utils/detect_system.sh"
source "$SCRIPT_DIR/utils/port_check.sh"
source "$SCRIPT_DIR/utils/install_tabby.sh"

# Load các module model
source "$SCRIPT_DIR/models/model_info.sh"
source "$SCRIPT_DIR/models/run_tabby.sh"

# Load các module menu
source "$SCRIPT_DIR/menus/main_menu.sh"
source "$SCRIPT_DIR/menus/cpu_models.sh"
source "$SCRIPT_DIR/menus/gpu_models.sh"
source "$SCRIPT_DIR/menus/macbook_models.sh"
source "$SCRIPT_DIR/menus/chat_models.sh"

# Phát hiện hệ điều hành
detect_os

# Kiểm tra GPU
check_gpu

# Hiển thị banner
show_banner() {
    clear
    echo "===================================================="
    echo "  ████████╗ █████╗ ██████╗ ██████╗ ██╗   ██╗       "
    echo "  ╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝       "
    echo "     ██║   ███████║██████╔╝██████╔╝ ╚████╔╝        "
    echo "     ██║   ██╔══██║██╔══██╗██╔══██╗  ╚██╔╝         "
    echo "     ██║   ██║  ██║██████╔╝██████╔╝   ██║          "
    echo "     ╚═╝   ╚═╝  ╚═╝╚═════╝ ╚═════╝    ╚═╝          "
    echo "                                                    "
    echo "    ██████╗ ██╗   ██╗███╗   ██╗███╗   ██╗███████╗██████╗  "
    echo "    ██╔══██╗██║   ██║████╗  ██║████╗  ██║██╔════╝██╔══██╗ "
    echo "    ██████╔╝██║   ██║██╔██╗ ██║██╔██╗ ██║█████╗  ██████╔╝ "
    echo "    ██╔══██╗██║   ██║██║╚██╗██║██║╚██╗██║██╔══╝  ██╔══██╗ "
    echo "    ██║  ██║╚██████╔╝██║ ╚████║██║ ╚████║███████╗██║  ██║ "
    echo "    ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ "
    echo "===================================================="
    echo "  AI Coding Assistant - Self-Hosted OpenSource"
    echo "  Access URL: http://localhost:$PORT"
    echo "===================================================="
    echo ""
    sleep 2
}

# Kiểm tra cài đặt
if ! check_tabby_installed; then
    install_tabby
fi

# Hiển thị banner
# After banner display and before main loop
show_banner

# Setup client configuration
setup_client_config() {
    local config_dir="$HOME/.tabby-client/agent"
    mkdir -p "$config_dir"
    
    # Ensure JWT_SECRET has a default value
    local client_token="${JWT_SECRET:-tabby-secure-token-do-not-change}"
    
    cat > "$config_dir/config.toml" << EOL
[server]
endpoint = "http://localhost:$PORT"
token = ""

[completion]
enable = true
prompt_template = "default"

[telemetry]
enable = false
EOL
    echo "Client configuration has been updated at $config_dir/config.toml"
    sleep 2
}

# Setup client configuration
setup_client_config

change_port() {
    read -p "Enter new port number (default: 8080): " new_port
    if [[ -n "$new_port" ]]; then
        PORT=$new_port
        setup_client_config  # Update client config with new port
        echo "Port changed to: $PORT"
    else
        echo "Using default port: $PORT"
    fi
    sleep 2
}

# Main loop
while true; do
    show_main_menu
    read choice
    
    case $choice in
        1)
            show_high_end_gpu_models_menu
            ;;
        2)
            show_mid_range_gpu_models_menu
            ;;
        3)
            show_cpu_models_menu
            ;;
        4)
            if [[ "$OS" == "macOS" ]]; then
                show_macbook_models_menu
            else
                echo "Tùy chọn này chỉ khả dụng cho MacBook."
                sleep 2
            fi
            ;;
        5)
            show_chat_models_menu
            ;;
        6)
            configure_settings
            ;;
        7)
            change_port
            ;;
        8)
            echo "Cảm ơn đã sử dụng Tabby Runner!"
            exit 0
            ;;
        *)
            echo "Lựa chọn không hợp lệ. Vui lòng thử lại."
            sleep 2
            ;;
    esac
done