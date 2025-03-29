# Tabby Runner

Tabby Runner is a shell script that helps you easily manage and run different models with Tabby AI Coding Assistant. It provides an interactive menu-based interface to select and configure various coding and chat models based on your hardware capabilities.

## Features

- **Automatic System Detection**
  - Detects operating system (macOS, Linux, Windows)
  - Identifies Apple Silicon/Intel chips on macOS
  - Detects NVIDIA GPUs and their capabilities
  - Automatically selects optimal device settings (metal, cuda, cpu)

- **Model Selection Based on Hardware**
  - High-end GPU models (16GB+ VRAM)
  - Mid-range GPU models (8GB+ VRAM)
  - CPU-only models
  - Specialized models for MacBook Pro (Metal/CPU)

- **Supported Code Models**
  - StarCoder (1B, 3B, 7B variants)
  - StarCoderPlus-7B
  - CodeLlama-7B
  - DeepSeek-Coder (1.3B, 6.7B variants)
  - CodeGemma-7B
  - SantaCoder
  - Magicoder-S-DS-6.7B
  - CodeQwen1.5-7B
  - WizardCoder-Python-13B
  - Mistral-7B

- **Chat Model Support**
  - Qwen2-1.5B-Instruct (default, lightweight)
  - Mistral-7B-Instruct-v0.2 (requires powerful GPU)
  - Option to disable chat model

- **Configuration Options**
  - Custom port selection
  - Device selection (metal/cuda/cpu)
  - Data directory configuration
  - Docker support for Linux and Windows

## Requirements

- macOS, Linux, or Windows
- For macOS:
  - Homebrew package manager
  - Apple Silicon (M1/M2/M3) for Metal support
- For Linux/Windows:
  - Docker (recommended)
  - NVIDIA GPU with CUDA support (optional)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/ai-devcontainer.git
cd ai-devcontainer