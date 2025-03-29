#!/bin/bash

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