#!/bin/bash

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
            save_config
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
        save_config
    else
        echo "Hệ điều hành không được hỗ trợ."
        echo "Vui lòng tham khảo trang web chính thức của Tabby để biết hướng dẫn cài đặt."
    fi
    
    echo ""
    echo "Cài đặt hoàn tất hoặc hướng dẫn đã được hiển thị."
    echo "Nhấn Enter để tiếp tục..."
    read
}