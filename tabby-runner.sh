#!/bin/bash

# Tabby Runner - Script để chọn và chạy các model khác nhau với Tabby

# Định nghĩa các biến mặc định
PORT=8080
DEVICE="metal"  # metal cho Mac M1/M2, cuda cho NVIDIA GPU, cpu cho máy không có GPU
DATA_DIR="$HOME/.tabby"

# Kiểm tra hệ điều hành
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

# Kiểm tra GPU
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

# Kiểm tra xem Tabby đã được cài đặt chưa
check_tabby_installed() {
    if command -v tabby &>/dev/null; then
        return 0  # Tabby đã được cài đặt
    else
        return 1  # Tabby chưa được cài đặt
    fi
}

# Hiển thị thông tin model
show_model_info() {
    local model_name=$1
    
    case $model_name in
        "TabbyML/StarCoder-1B")
            echo "Model: StarCoder-1B"
            echo "Kích thước: 1B tham số"
            echo "Giấy phép: BigCode OpenRAIL-M"
            echo "Mô tả: Model nhỏ gọn, thích hợp cho CPU/Metal, đạt điểm 25.6 HumanEval"
            ;;
        "TabbyML/StarCoder-3B")
            echo "Model: StarCoder-3B"
            echo "Kích thước: 3B tham số"
            echo "Giấy phép: BigCode OpenRAIL-M"
            echo "Mô tả: Model cân bằng, đạt điểm 32.9 HumanEval, yêu cầu GPU tốt"
            ;;
        "TabbyML/StarCoder-7B")
            echo "Model: StarCoder-7B"
            echo "Kích thước: 7B tham số"
            echo "Giấy phép: BigCode OpenRAIL-M"
            echo "Mô tả: Model lớn, đạt điểm 33.2 HumanEval, yêu cầu NVIDIA GPU lớn (16GB+ VRAM)"
            ;;
        "TabbyML/StarCoderPlus-7B")
            echo "Model: StarCoderPlus-7B"
            echo "Kích thước: 7B tham số"
            echo "Giấy phép: BigCode OpenRAIL-M"
            echo "Mô tả: Phiên bản cải tiến của StarCoder-7B, đạt điểm 35.3 HumanEval"
            ;;
        "TabbyML/CodeLlama-7B")
            echo "Model: CodeLlama-7B"
            echo "Kích thước: 7B tham số"
            echo "Giấy phép: Llama 2 Community License"
            echo "Mô tả: Model từ Meta, đạt điểm 38.6 HumanEval, yêu cầu NVIDIA GPU lớn"
            ;;
        "TabbyML/DeepSeek-Coder-1.3B")
            echo "Model: DeepSeek-Coder-1.3B"
            echo "Kích thước: 1.3B tham số"
            echo "Giấy phép: DeepSeek License"
            echo "Mô tả: Model nhỏ gọn từ DeepSeek, đạt điểm 31.3 HumanEval, phù hợp cho CPU/Metal"
            ;;
        "TabbyML/DeepSeek-Coder-6.7B")
            echo "Model: DeepSeek-Coder-6.7B"
            echo "Kích thước: 6.7B tham số"
            echo "Giấy phép: DeepSeek License"
            echo "Mô tả: Model có hiệu suất cao, đạt điểm 51.0 HumanEval, yêu cầu NVIDIA GPU lớn"
            ;;
        "TabbyML/CodeGemma-7B")
            echo "Model: CodeGemma-7B"
            echo "Kích thước: 7B tham số"
            echo "Giấy phép: Google Gemma License"
            echo "Mô tả: Model mã hóa mới từ Google, đạt điểm 42.1 HumanEval, yêu cầu GPU mạnh"
            ;;
        "TabbyML/SantaCoder")
            echo "Model: SantaCoder"
            echo "Kích thước: 1.1B tham số"
            echo "Giấy phép: BigCode OpenRAIL-M"
            echo "Mô tả: Model nhỏ gọn, đạt điểm 27.0 HumanEval, tối ưu cho CPU, tập trung vào Python, Java, JavaScript"
            ;;
        "TabbyML/Magicoder-S-DS-6.7B")
            echo "Model: Magicoder-S-DS-6.7B"
            echo "Kích thước: 6.7B tham số"
            echo "Giấy phép: DeepSeek License"
            echo "Mô tả: Model hiệu suất cao, đạt điểm 63.8 HumanEval, yêu cầu NVIDIA GPU lớn"
            ;;
        "TabbyML/CodeQwen1.5-7B")
            echo "Model: CodeQwen1.5-7B"
            echo "Kích thước: 7B tham số"
            echo "Giấy phép: Qwen License"
            echo "Mô tả: Model từ Alibaba Cloud, đạt điểm 44.5 HumanEval, yêu cầu GPU mạnh"
            ;;
        "TabbyML/WizardCoder-Python-13B")
            echo "Model: WizardCoder-Python-13B"
            echo "Kích thước: 13B tham số"
            echo "Giấy phép: Llama 2 Community License"
            echo "Mô tả: Model chuyên về Python, đạt điểm 64.1 HumanEval, yêu cầu NVIDIA GPU lớn (24GB+ VRAM)"
            ;;
        "TabbyML/Mistral-7B")
            echo "Model: Mistral-7B"
            echo "Kích thước: 7B tham số"
            echo "Giấy phép: Apache 2.0"
            echo "Mô tả: Model LLM đa năng với khả năng chạy code, đạt điểm 36.0 HumanEval"
            ;;
        "Qwen2-1.5B-Instruct")
            echo "Model: Qwen2-1.5B-Instruct"
            echo "Kích thước: 1.5B tham số"
            echo "Giấy phép: Qwen License"
            echo "Mô tả: Chat model nhẹ từ Alibaba Cloud, phù hợp cho trò chuyện"
            ;;
        "Mistral-7B-Instruct-v0.2")
            echo "Model: Mistral-7B-Instruct-v0.2"
            echo "Kích thước: 7B tham số"
            echo "Giấy phép: Apache 2.0"
            echo "Mô tả: Chat model đa năng, phù hợp cho trò chuyện và tư vấn"
            ;;
        *)
            echo "Không có thông tin cho model này."
            ;;
    esac
}

# Cài đặt Tabby dựa trên hệ điều hành
install_tabby() {
    show_header
    echo "TABBY CHƯA ĐƯỢC CÀI ĐẶT"
    echo "-----------------------------------"
    echo "Phát hiện hệ điều hành: $OS"
    if [[ "$OS" == "macOS" ]]; then
        echo "Loại chip: $MAC_CHIP"
    elif [[ "$OS" == "Linux" ]]; then
        echo "Distro: $DISTRO"
    fi
    echo ""
    
    echo "Bạn có muốn cài đặt Tabby không? (y/n): "
    read install_choice
    
    if [[ "$install_choice" != "y" && "$install_choice" != "Y" ]]; then
        echo "Cài đặt đã bị hủy."
        echo "Nhấn Enter để quay lại..."
        read
        return
    fi
    
    if [[ "$OS" == "macOS" ]]; then
        echo "Đang cài đặt Tabby trên macOS..."
        if ! command -v brew &>/dev/null; then
            echo "Homebrew chưa được cài đặt. Cài đặt Homebrew trước..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install tabbyml/tabby/tabby
        
    elif [[ "$OS" == "Linux" ]]; then
        echo "Đang cài đặt Tabby trên Linux..."
        echo "Phương pháp cài đặt được khuyến nghị cho Linux là Docker:"
        echo "1) Cài đặt qua Docker"
        echo "2) Cài đặt trực tiếp (nếu có)"
        echo "Lựa chọn phương pháp cài đặt: "
        read linux_install_method
        
        if [[ "$linux_install_method" == "1" ]]; then
            echo "Hướng dẫn cài đặt Docker:"
            echo "curl -fsSL https://get.docker.com -o get-docker.sh"
            echo "sudo sh get-docker.sh"
            echo ""
            echo "Sau khi cài đặt Docker, bạn có thể chạy Tabby với lệnh:"
            echo "docker run -it --gpus all -p 8080:8080 -v \$HOME/.tabby:/data tabbyml/tabby serve --model TabbyML/StarCoder-1B --device cuda"
            echo ""
            echo "Script này sẽ tự động chuyển sang chế độ Docker nếu bạn tiếp tục."
            USE_DOCKER=true
        else
            echo "Cài đặt trực tiếp chưa được hỗ trợ trong script này."
            echo "Vui lòng tham khảo trang web chính thức của Tabby để biết hướng dẫn."
        fi
        
    elif [[ "$OS" == "Windows"* ]]; then
        echo "Đang cài đặt Tabby trên Windows..."
        echo "Phương pháp cài đặt được khuyến nghị cho Windows là Docker:"
        echo "1) Tải và cài đặt Docker Desktop cho Windows"
        echo "2) Chạy Tabby thông qua Docker:"
        echo "   docker run -it --gpus all -p 8080:8080 -v %USERPROFILE%\\.tabby:/data tabbyml/tabby serve --model TabbyML/StarCoder-1B --device cuda"
        USE_DOCKER=true
    else
        echo "Hệ điều hành không được hỗ trợ."
        echo "Vui lòng tham khảo trang web chính thức của Tabby để biết hướng dẫn cài đặt."
    fi
    
    echo ""
    echo "Cài đặt hoàn tất hoặc hướng dẫn đã được hiển thị."
    echo "Nhấn Enter để tiếp tục..."
    read
}

# Function hiển thị header
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
    echo "====================================="
    echo ""
}

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
            fi
        else
            echo "Port $PORT khả dụng."
        fi
    fi
}

# Function hiển thị menu model cho máy có GPU mạnh
show_high_end_gpu_models_menu() {
    show_header
    echo "CHỌN MODEL CHO MÁY CÓ GPU MẠNH (16GB+ VRAM)"
    echo "-----------------------------------"
    echo "1) TabbyML/StarCoder-7B (7B tham số, 33.2 HumanEval)"
    echo "2) TabbyML/StarCoderPlus-7B (7B tham số, 35.3 HumanEval)"
    echo "3) TabbyML/CodeLlama-7B (7B tham số, 38.6 HumanEval)"
    echo "4) TabbyML/DeepSeek-Coder-6.7B (6.7B tham số, 51.0 HumanEval)"
    echo "5) TabbyML/Magicoder-S-DS-6.7B (6.7B tham số, 63.8 HumanEval)"
    echo "6) TabbyML/CodeQwen1.5-7B (7B tham số, 44.5 HumanEval)"
    echo "7) TabbyML/CodeGemma-7B (7B tham số, 42.1 HumanEval)"
    echo "8) TabbyML/WizardCoder-Python-13B (13B tham số, 64.1 HumanEval)"
    echo "9) Quay lại menu chính"
    echo ""
    echo -n "Nhập lựa chọn của bạn [1-9]: "
    
    read high_end_choice
    case $high_end_choice in
        1)
            show_model_info "TabbyML/StarCoder-7B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                run_tabby "TabbyML/StarCoder-7B" "Qwen2-1.5B-Instruct" ""
            fi
            ;;
        2)
            show_model_info "TabbyML/StarCoderPlus-7B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                run_tabby "TabbyML/StarCoderPlus-7B" "Qwen2-1.5B-Instruct" ""
            fi
            ;;
        3)
            show_model_info "TabbyML/CodeLlama-7B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                run_tabby "TabbyML/CodeLlama-7B" "Qwen2-1.5B-Instruct" ""
            fi
            ;;
        4)
            show_model_info "TabbyML/DeepSeek-Coder-6.7B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                run_tabby "TabbyML/DeepSeek-Coder-6.7B" "Qwen2-1.5B-Instruct" ""
            fi
            ;;
        5)
            show_model_info "TabbyML/Magicoder-S-DS-6.7B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                run_tabby "TabbyML/Magicoder-S-DS-6.7B" "Qwen2-1.5B-Instruct" ""
            fi
            ;;
        6)
            show_model_info "TabbyML/CodeQwen1.5-7B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                run_tabby "TabbyML/CodeQwen1.5-7B" "Qwen2-1.5B-Instruct" ""
            fi
            ;;
        7)
            show_model_info "TabbyML/CodeGemma-7B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                run_tabby "TabbyML/CodeGemma-7B" "Qwen2-1.5B-Instruct" ""
            fi
            ;;
        8)
            show_model_info "TabbyML/WizardCoder-Python-13B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                run_tabby "TabbyML/WizardCoder-Python-13B" "Qwen2-1.5B-Instruct" ""
            fi
            ;;
        9)
            return
            ;;
        *)
            echo "Lựa chọn không hợp lệ. Vui lòng thử lại."
            sleep 2
            show_high_end_gpu_models_menu
            ;;
    esac
}

# Function hiển thị menu model cho máy có GPU thông thường
show_mid_range_gpu_models_menu() {
    show_header
    echo "CHỌN MODEL CHO MÁY CÓ GPU THÔNG THƯỜNG (8GB+ VRAM)"
    echo "-----------------------------------"
    echo "1) TabbyML/StarCoder-3B (3B tham số, 32.9 HumanEval)"
    echo "2) TabbyML/StarCoder-1B (1B tham số, 25.6 HumanEval)"
    echo "3) TabbyML/DeepSeek-Coder-1.3B (1.3B tham số, 31.3 HumanEval)"
    echo "4) TabbyML/SantaCoder (1.1B tham số, 27.0 HumanEval)"
    echo "5) TabbyML/Mistral-7B (7B tham số, 36.0 HumanEval)"
    echo "6) Quay lại menu chính"
    echo ""
    echo -n "Nhập lựa chọn của bạn [1-6]: "
    
    read mid_range_choice
    case $mid_range_choice in
        1)
            show_model_info "TabbyML/StarCoder-3B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                run_tabby "TabbyML/StarCoder-3B" "Qwen2-1.5B-Instruct" ""
            fi
            ;;
        2)
            show_model_info "TabbyML/StarCoder-1B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                run_tabby "TabbyML/StarCoder-1B" "Qwen2-1.5B-Instruct" ""
            fi
            ;;
        3)
            show_model_info "TabbyML/DeepSeek-Coder-1.3B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                run_tabby "TabbyML/DeepSeek-Coder-1.3B" "Qwen2-1.5B-Instruct" ""
            fi
            ;;
        4)
            show_model_info "TabbyML/SantaCoder"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                run_tabby "TabbyML/SantaCoder" "Qwen2-1.5B-Instruct" ""
            fi
            ;;
        5)
            show_model_info "TabbyML/Mistral-7B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                run_tabby "TabbyML/Mistral-7B" "Qwen2-1.5B-Instruct" ""
            fi
            ;;
        6)
            return
            ;;
        *)
            echo "Lựa chọn không hợp lệ. Vui lòng thử lại."
            sleep 2
            show_mid_range_gpu_models_menu
            ;;
    esac
}

# Function hiển thị menu model cho máy chỉ có CPU
show_cpu_models_menu() {
    show_header
    echo "CHỌN MODEL CHO MÁY KHÔNG CÓ GPU (CPU)"
    echo "-----------------------------------"
    echo "1) TabbyML/StarCoder-1B (1B tham số, 25.6 HumanEval)"
    echo "2) TabbyML/DeepSeek-Coder-1.3B (1.3B tham số, 31.3 HumanEval)"
    echo "3) TabbyML/SantaCoder (1.1B tham số, 27.0 HumanEval)"
    echo "4) Quay lại menu chính"
    echo ""
    echo -n "Nhập lựa chọn của bạn [1-4]: "
    
    read cpu_choice
    case $cpu_choice in
        1)
            show_model_info "TabbyML/StarCoder-1B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                DEVICE="cpu"
                run_tabby "TabbyML/StarCoder-1B" "Qwen2-1.5B-Instruct" ""
            fi
            ;;
        2)
            show_model_info "TabbyML/DeepSeek-Coder-1.3B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                DEVICE="cpu"
                run_tabby "TabbyML/DeepSeek-Coder-1.3B" "Qwen2-1.5B-Instruct" ""
            fi
            ;;
        3)
            show_model_info "TabbyML/SantaCoder"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                DEVICE="cpu"
                run_tabby "TabbyML/SantaCoder" "Qwen2-1.5B-Instruct" ""
            fi
            ;;
        4)
            return
            ;;
        *)
            echo "Lựa chọn không hợp lệ. Vui lòng thử lại."
            sleep 2
            show_cpu_models_menu
            ;;
    esac
}

# Function hiển thị menu model dành riêng cho MacBook Pro
show_macbook_models_menu() {
    show_header
    echo "CHỌN MODEL CHO MACBOOK PRO"
    echo "-----------------------------------"
    if [[ "$MAC_CHIP" == "Apple Silicon (M1/M2/M3)" ]]; then
        echo "Phát hiện MacBook Pro với Apple Silicon"
        echo "1) TabbyML/StarCoder-1B với Metal (khuyến nghị, 25.6 HumanEval)"
        echo "2) TabbyML/DeepSeek-Coder-1.3B với Metal (31.3 HumanEval)"
        echo "3) TabbyML/SantaCoder với Metal (27.0 HumanEval)"
        echo "4) TabbyML/StarCoder-1B với CPU (chậm hơn)"
        echo "5) Quay lại menu chính"
        echo ""
        echo -n "Nhập lựa chọn của bạn [1-5]: "
        
        read mac_choice
        case $mac_choice in
            1)
                show_model_info "TabbyML/StarCoder-1B"
                echo ""
                echo -n "Xác nhận chọn model này? (y/n): "
                read confirm
                if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                    DEVICE="metal"
                    run_tabby "TabbyML/StarCoder-1B" "Qwen2-1.5B-Instruct" ""
                fi
                ;;
            2)
                show_model_info "TabbyML/DeepSeek-Coder-1.3B"
                echo ""
                echo -n "Xác nhận chọn model này? (y/n): "
                read confirm
                if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                    DEVICE="metal"
                    run_tabby "TabbyML/DeepSeek-Coder-1.3B" "Qwen2-1.5B-Instruct" ""
                fi
                ;;
            3)
                show_model_info "TabbyML/SantaCoder"
                echo ""
                echo -n "Xác nhận chọn model này? (y/n): "
                read confirm
                if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                    DEVICE="metal"
                    run_tabby "TabbyML/SantaCoder" "Qwen2-1.5B-Instruct" ""
                fi
                ;;
            4)
                show_model_info "TabbyML/StarCoder-1B"
                echo ""
                echo -n "Xác nhận chọn model này? (y/n): "
                read confirm
                if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                    DEVICE="cpu"
                    run_tabby "TabbyML/StarCoder-1B" "Qwen2-1.5B-Instruct" ""
                fi
                ;;
            5)
                return
                ;;
            *)
                echo "Lựa chọn không hợp lệ. Vui lòng thử lại."
                sleep 2
                show_macbook_models_menu
                ;;
        esac
    else
        echo "Phát hiện MacBook Pro với Intel Chip"
        echo "1) TabbyML/StarCoder-1B với CPU (25.6 HumanEval)"
        echo "2) TabbyML/DeepSeek-Coder-1.3B với CPU (31.3 HumanEval)" 
        echo "3) TabbyML/SantaCoder với CPU (27.0 HumanEval)"
        echo "4) Quay lại menu chính"
        echo ""
        echo -n "Nhập lựa chọn của bạn [1-4]: "
        
        read mac_intel_choice
        case $mac_intel_choice in
            1)
                show_model_info "TabbyML/StarCoder-1B"
                echo ""
                echo -n "Xác nhận chọn model này? (y/n): "
                read confirm
                if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                    DEVICE="cpu"
                    run_tabby "TabbyML/StarCoder-1B" "Qwen2-1.5B-Instruct" ""
                fi
                ;;
            2)
                show_model_info "TabbyML/DeepSeek-Coder-1.3B"
                echo ""
                echo -n "Xác nhận chọn model này? (y/n): "
                read confirm
                if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                    DEVICE="cpu"
                    run_tabby "TabbyML/DeepSeek-Coder-1.3B" "Qwen2-1.5B-Instruct" ""
                fi
                ;;
            3)
                show_model_info "TabbyML/SantaCoder"
                echo ""
                echo -n "Xác nhận chọn model này? (y/n): "
                read confirm
                if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                    DEVICE="cpu"
                    run_tabby "TabbyML/SantaCoder" "Qwen2-1.5B-Instruct" ""
                fi
                ;;
            4)
                return
                ;;
            *)
                echo "Lựa chọn không hợp lệ. Vui lòng thử lại."
                sleep 2
                show_macbook_models_menu
                ;;
        esac
    fi
}

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
            sleep 2
            ;;
        2)
            show_model_info "Mistral-7B-Instruct-v0.2"
            CHAT_MODEL="Mistral-7B-Instruct-v0.2"
            echo "Đã chọn chat model: $CHAT_MODEL"
            sleep 2
            ;;
        3)
            CHAT_MODEL=""
            echo "Không sử dụng chat model"
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

# Function cấu hình thiết lập
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
    
    echo ""
    echo "Thiết lập đã được lưu!"
    echo "Nhấn Enter để quay lại menu chính..."
    read
}

# Function đổi port
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
    fi
    
    echo ""
    echo "Nhấn Enter để quay lại menu chính..."
    read
}

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
    
    if [[ "$USE_DOCKER" == true ]]; then
        # Sử dụng Docker
        if [[ "$OS" == "Windows"* ]]; then
            docker_data_path="%USERPROFILE%\\.tabby"
        else
            docker_data_path="$HOME/.tabby"
        fi
        
        if [ ! -z "$chat_model" ]; then
            if [[ "$HAS_GPU" == true && "$DEVICE" != "cpu" ]]; then
                docker run -it --gpus all -p $PORT:8080 -v $docker_data_path:/data tabbyml/tabby serve --model $model --chat-model $chat_model --device $DEVICE $extra_args
            else
                docker run -it -p $PORT:8080 -v $docker_data_path:/data tabbyml/tabby serve --model $model --chat-model $chat_model --device cpu $extra_args
            fi
        else
            if [[ "$HAS_GPU" == true && "$DEVICE" != "cpu" ]]; then
                docker run -it --gpus all -p $PORT:8080 -v $docker_data_path:/data tabbyml/tabby serve --model $model --device $DEVICE $extra_args
            else
                docker run -it -p $PORT:8080 -v $docker_data_path:/data tabbyml/tabby serve --model $model --device cpu $extra_args
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

# Main code
# Khởi tạo biến
USE_DOCKER=false
CHAT_MODEL="Qwen2-1.5B-Instruct"

# Phát hiện hệ điều hành
detect_os

# Kiểm tra GPU
check_gpu

# Kiểm tra cài đặt
if ! check_tabby_installed; then
    install_tabby
fi

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