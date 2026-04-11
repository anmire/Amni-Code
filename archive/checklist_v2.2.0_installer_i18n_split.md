# Checklist: v2.2.0 — Installers, Translation, Split Windows
## Date: 2026-04-10

### Phase 1: i18n Translation System
- [x] Add translation JSON dict to index.html (10 languages)
- [x] Create `t()` function for string lookup with English fallback
- [x] Replace all hardcoded UI strings with `t()` calls
- [x] Add language selector dropdown to settings panel
- [x] Add RTL support for Arabic (dir attribute)
- [x] Persist language choice in localStorage

### Phase 2: Split Windows / Multi-Agent Panes
- [x] Add CSS for split panes (`.pane`, `.pane-divider`, `.pane-header`)
- [x] Create pane state management (array of pane objects)
- [x] Clone chat-col into independent pane components
- [x] Each pane gets own sessionId, messages, input, model selector
- [x] Add "Split View" button to header + command palette
- [x] Draggable divider between panes
- [x] Max 3 panes, close pane button
- [x] Each pane sends to its own /api/chat endpoint

### Phase 3: Cross-Platform Installers
- [x] Create `packaging/` directory structure
- [x] Create WiX XML manifest for Windows MSI
- [x] Create macOS .app bundle script (+ DMG)
- [x] Create Linux deb packaging script
- [x] Upgrade install_gui.py: model picker, PATH setup
- [x] Add build-packages script (build-all.sh)

### Phase 4: Finalize
- [x] Update Cargo.toml version to 2.2.0
- [x] Update version strings in main.rs and index.html
- [x] Update architecture_map.md
- [x] Update changelog.md
- [x] Run cargo check + python syntax check
- [ ] Test split pane functionality
- [ ] Test i18n language switching
- [ ] Commit and push
