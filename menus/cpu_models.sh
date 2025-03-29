#!/bin/bash

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
                save_config
                run_tabby "TabbyML/StarCoder-1B" "$CHAT_MODEL" ""
            fi
            ;;
        2)
            show_model_info "TabbyML/DeepSeek-Coder-1.3B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                DEVICE="cpu"
                save_config
                run_tabby "TabbyML/DeepSeek-Coder-1.3B" "$CHAT_MODEL" ""
            fi
            ;;
        3)
            show_model_info "TabbyML/SantaCoder"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                DEVICE="cpu"
                save_config
                run_tabby "TabbyML/SantaCoder" "$CHAT_MODEL" ""
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