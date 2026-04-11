# Amni-Code Architecture Map v2.2.0
## Overview
Single-binary AI coding agent. Rust/Axum backend with embedded HTML UI. No Python/Node/npm runtime deps. Per-session cwd for concurrent windows in diff dirs, no max-iters. v2.2.0 adds i18n (10 languages), split panes (up to 3 independent agent sessions), and cross-platform installers.
## Core Files
src/main.rs: Axum web server + full agent engine
- App state: sessions (HashMap w/ working_dir), config, cwd
- 6 tools: read_file,write_file,edit_file,run_command,list_directory,search_files
- Agent loop: unbounded (soft<100) LLM call->tool->repeat until no tools
- UI header themed cwd display
- LLM integration: OpenAI-compatible API (Ollama/OpenAI/Anthropic/xAI via provider config)
- Routes: GET / (serve embedded UI), POST /api/chat (agent), GET|POST /api/config, GET /health
- Auto-opens browser on launch
static/index.html: Self-contained single-file UI (HTML+CSS+JS inline)
- Chat interface with markdown rendering
- Code-change diff visualizer (side panel, auto-opens on file changes)
- Settings panel (provider/model/key/url/working_dir/auto_approve toggle + language selector)
- Welcome/onboarding screen with quick-start prompts
- Tool execution badges with expandable details
- i18n system: I18N dict (en/es/fr/de/ja/zh/ko/pt/ar/ru), t(key) function, data-i18n attributes, RTL for Arabic
- Split pane system: panes[] array (max 3), createPane/closePane/paneSend, draggable dividers, independent SSE sessions per pane
Cargo.toml: Rust deps — axum 0.7, tokio, serde, reqwest, uuid, open, futures, tokio-stream
run.bat: One-click launcher — checks Rust, builds if needed, runs binary
install_gui.py: tkinter GUI installer (v2.2.0) — 8-step wizard, API key setup, model picker w/ checkboxes, PATH setup, desktop shortcut
## Packaging
packaging/windows/amni-code.wxs: WiX XML manifest for MSI — perUser install, PATH env, Start Menu + desktop shortcuts
packaging/macos/build-dmg.sh: Creates .app bundle (Info.plist, binary) + DMG via hdiutil
packaging/linux/build-deb.sh: Creates .deb package (DEBIAN/control, /usr/local/bin/amni, .desktop file)
packaging/build-all.sh: OS-detection wrapper — runs cargo build then platform-specific packager
## Rust Installer (installer/)
installer/Cargo.toml: Standalone Rust binary — tao+wry+axum (same stack as main app), reqwest for HTTP model downloads
installer/src/main.rs: Axum server + tao/wry window, routes: GET / (UI), GET /api/prereqs (detect Rust/Git/OS), POST /api/install (SSE progress stream), POST /api/open (launch download URLs)
installer/static/installer.html: WebGL plasma shader background, 5-page wizard (Welcome/Prereqs/Options/Install/Done), glass morphism UI, model picker, PATH setup, two modes (pre-built binary download OR build from source)
Eliminates Python dependency entirely — model downloads use HuggingFace HTTP API via reqwest, no huggingface-cli needed
## Data Flow
User input -> POST /api/chat -> agent_loop -> llm_call (OpenAI-compatible) -> tool execution -> repeat until LLM returns text-only -> JSON response with message + tool_calls array
## Config Providers
- ollama: localhost:11434 (default, no key needed)
- openai: api.openai.com (Bearer token)
- anthropic: api.anthropic.com (x-api-key header)
- xai: api.x.ai (Bearer token)
## Backups
backups/v1.0.0/: main.rs.bak, index.html.bak, run.bat.bak, Cargo.toml.bak
backups/v2.2.0/: main.rs.bak, index.html.bak, install_gui.py.bak, Cargo.toml.bak
