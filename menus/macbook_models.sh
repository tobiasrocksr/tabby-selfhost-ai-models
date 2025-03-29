#!/bin/bash

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
                    DEVICE="metal"
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
                    DEVICE="metal"
                    save_config
                    run_tabby "TabbyML/SantaCoder" "$CHAT_MODEL" ""
                fi
                ;;
            4)
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
                show_macbook_models_menu
                ;;
        esac
    fi
}