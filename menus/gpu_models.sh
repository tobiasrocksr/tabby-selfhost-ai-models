#!/bin/bash

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
                run_tabby "TabbyML/StarCoder-7B" "$CHAT_MODEL" ""
            fi
            ;;
        2)
            show_model_info "TabbyML/StarCoderPlus-7B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                run_tabby "TabbyML/StarCoderPlus-7B" "$CHAT_MODEL" ""
            fi
            ;;
        3)
            show_model_info "TabbyML/CodeLlama-7B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                run_tabby "TabbyML/CodeLlama-7B" "$CHAT_MODEL" ""
            fi
            ;;
        4)
            show_model_info "TabbyML/DeepSeek-Coder-6.7B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                run_tabby "TabbyML/DeepSeek-Coder-6.7B" "$CHAT_MODEL" ""
            fi
            ;;
        5)
            show_model_info "TabbyML/Magicoder-S-DS-6.7B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                run_tabby "TabbyML/Magicoder-S-DS-6.7B" "$CHAT_MODEL" ""
            fi
            ;;
        6)
            show_model_info "TabbyML/CodeQwen1.5-7B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                run_tabby "TabbyML/CodeQwen1.5-7B" "$CHAT_MODEL" ""
            fi
            ;;
        7)
            show_model_info "TabbyML/CodeGemma-7B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                run_tabby "TabbyML/CodeGemma-7B" "$CHAT_MODEL" ""
            fi
            ;;
        8)
            show_model_info "TabbyML/WizardCoder-Python-13B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                run_tabby "TabbyML/WizardCoder-Python-13B" "$CHAT_MODEL" ""
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
                run_tabby "TabbyML/StarCoder-3B" "$CHAT_MODEL" ""
            fi
            ;;
        2)
            show_model_info "TabbyML/StarCoder-1B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                run_tabby "TabbyML/StarCoder-1B" "$CHAT_MODEL" ""
            fi
            ;;
        3)
            show_model_info "TabbyML/DeepSeek-Coder-1.3B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                run_tabby "TabbyML/DeepSeek-Coder-1.3B" "$CHAT_MODEL" ""
            fi
            ;;
        4)
            show_model_info "TabbyML/SantaCoder"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                run_tabby "TabbyML/SantaCoder" "$CHAT_MODEL" ""
            fi
            ;;
        5)
            show_model_info "TabbyML/Mistral-7B"
            echo ""
            echo -n "Xác nhận chọn model này? (y/n): "
            read confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                run_tabby "TabbyML/Mistral-7B" "$CHAT_MODEL" ""
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