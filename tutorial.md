# Amni-Code Agent Tutorial

Amni-Code is a custom AI coding assistant built in Rust with a web-based UI inspired by Ollama and Claude Code, featuring advanced VSCode-like capabilities.

## Installation

### Option 1: GUI Installer (Recommended)

1. **Download and Run**:
   ```bash
   git clone https://github.com/anmire/Amni-Code.git
   cd amni-code
   install.bat
   # Choose option [1] for GUI Installer
   ```

2. **What the GUI Installer Provides**:
   - **Progress bars** showing installation progress
   - **Real-time logging** of all steps
   - **Interactive prompts** for hardware setup
   - **Visual feedback** throughout the process
   - **Desktop shortcut** creation
   - **Hardware detection** with specific guidance for AMD/NVIDIA

### Option 2: Command-Line Installer

1. **Run Command-Line Version**:
   ```bash
   install.bat
   # Choose option [2] for Command-Line Installer
   ```

2. **What it does**:
   - Same functionality as GUI installer
   - Text-based with step counters
   - Faster for experienced users
   - Suitable for automation

### What Both Installers Do

- ✅ Install Rust toolchain if needed
- ✅ Set up Python (from Microsoft Store if required)
- ✅ Detect NVIDIA/AMD GPUs and configure acceleration
- ✅ Prompt for HIP/ROCm installation on AMD GPUs
- ✅ Install all Python dependencies (PyTorch, transformers, etc.)
- ✅ Build the Rust application
- ✅ Download AI models from HuggingFace
- ✅ Set up everything for immediate use

## Running the Application

1. **Start the Server**:
   ```bash
   target\release\amni-code.exe
   ```

2. **Open in Browser**:
   - Navigate to `http://localhost:3000`
   - The web interface will load

## User Interface

### Main Chat Interface
- **Sidebar**: Model selection and chat history
- **Main Area**: Chat with the AI assistant
- **Input**: Type your questions or code requests
- **Send**: Click Send or press Enter

### Advanced Features (VSCode-like)

#### Code Editor Tab
- Edit code directly in the browser
- Syntax highlighting (basic)
- Save/load code snippets

#### Terminal Tab
- Simulate command execution
- Run shell commands through the AI
- View output in real-time

#### Files Tab
- Browse project file structure
- Open files for editing
- File operations through AI

## Model Selection

Currently supports mock responses. Future versions will include:
- **Qwen3.5-9B-Neo**: Full-featured model for complex tasks
- **MLX-Qwen3.5-4B**: Optimized lightweight model

Models will support both safetensors and GGUF formats automatically.

## Usage Examples

### Code Generation
```
Write a Python function to calculate fibonacci numbers recursively.
```

### Code Review
```
Review this JavaScript code and suggest improvements:
[ paste your code ]
```

### Terminal Commands
```
Help me set up a new React project with TypeScript.
```

### File Operations
```
Create a new file called utils.js with helper functions.
```

## Current Status

**Version 0.3.0**: Basic UI with mock AI responses
- ✅ Web-based interface inspired by Ollama/Claude
- ✅ Advanced VSCode-like panels (Code Editor, Terminal, Files)
- ✅ Rust backend with Axum server
- ✅ Standalone executable (no external dependencies)
- 🚧 Model integration (coming in next version)
- 🚧 GPU acceleration (coming in next version)

## Development

To modify the application:
1. Edit Rust code in `src/main.rs`
2. Modify frontend in `static/`
3. Rebuild with `cargo build --release`

## Troubleshooting

### Common Issues
- **Port 3000 busy**: Change port in `src/main.rs`
- **Build fails**: Ensure Rust is installed correctly
- **Browser doesn't load**: Check firewall/antivirus

### Performance Tips
- The app currently runs mock responses for instant feedback
- Real model integration will require significant RAM (16GB+)

## Future Features

- **Model Downloads**: Automatic download from HuggingFace
- **Hardware Acceleration**: CUDA/HIP GPU support
- **Multiple Models**: Support for various Qwen and other models
- **Advanced Code Features**: Syntax highlighting, IntelliSense-like suggestions
- **File System Integration**: Direct file operations
- **Terminal Integration**: Real command execution

## Contributing

This is a custom implementation inspired by existing tools but built from scratch. Contributions welcome!

## License

[Add your license here]