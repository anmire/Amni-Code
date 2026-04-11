# Guardian Council — v2.2.0: Installers, Translation, Split Windows
**Date**: 2026-04-10
**Facilitator**: Rikku

---

## Feature 1: Cross-Platform GUI Installer (MSI/DMG/deb) + PATH + Model Download

### Auron (Security & Architecture)
- **Proposal**: Use `cargo-wix` for Windows MSI, `cargo-bundle` for macOS .app bundle, `cargo-deb` for Debian. Each produces a native package with proper PATH injection and uninstall support.
- **Concerns**: MSI must not store API keys in the installer itself. PATH changes require admin elevation on Windows. Model downloads should verify checksums to prevent tamper.
- **Vote**: Build native packages per-OS with a unified build script (`build-packages.sh`).

### Lulu (UX & Accessibility)
- **Proposal**: Upgrade existing `install_gui.py` to support all 3 features: wizard-style flow with pages (Welcome → Options → Model Selection → Install → Done). Add OS detection, PATH toggle, model picker with size estimates.
- **Concerns**: tkinter looks dated. For MSI, the WiX UI is separate from our custom installer. Need to keep both pathways working.
- **Vote**: Enhance `install_gui.py` as the universal installer AND create WiX/packaging configs for native distribution.

### Wakka (Reliability & Testing)
- **Proposal**: Add a `packaging/` directory with WiX XML for Windows, shell scripts for macOS DMG and Linux deb/AppImage. Test with CI pipelines.
- **Concerns**: WiX requires the WiX Toolset installed. DMG creation needs `hdiutil` (macOS only). Deb needs `dpkg-deb`. Cross-compiling is complex. Focus on build scripts that work on native OS first.
- **Vote**: Per-OS build scripts in `packaging/`, CI later.

### Kimahri (Minimalism)
- **Proposal**: One unified install script per OS. Windows: PowerShell. macOS/Linux: shell script. No external tooling deps. Keep it simple.
- **Vote**: Shell scripts that download pre-built binaries from GitHub Releases.

**MAJORITY RULING**: Enhanced `install_gui.py` as universal installer + WiX XML for MSI + shell scripts for macOS/Linux packaging in `packaging/` directory.

---

## Feature 2: Translation / i18n Packages

### Auron
- **Proposal**: JSON-based translation dictionary embedded in index.html. `window.T` object with locale keys. All UI strings go through `t('key')` function. Store language preference in localStorage.
- **Concerns**: Don't use external translation services at runtime — bundle all strings. Keep English as fallback for missing keys.
- **Vote**: Inline JSON translations, `t()` function, language selector in settings.

### Lulu
- **Proposal**: Start with 10 languages: English, Spanish, French, German, Japanese, Chinese (Simplified), Korean, Portuguese, Arabic, Russian. Add language selector to settings panel. RTL support for Arabic.
- **Concerns**: UI layout must handle longer strings (German ~30% longer than English). RTL needs `dir="rtl"` on body.
- **Vote**: 10 languages with RTL support. Language picker in settings.

### Wakka
- **Proposal**: Translations in a separate `translations.js` file loaded at runtime. Easier to maintain and contribute to.
- **Vote**: Separate file but since we embed everything, inline in index.html is fine.

### Kimahri
- **Proposal**: Minimal approach — `t()` wrapper, JSON dict, 5 languages max for initial release.
- **Vote**: Start with 8 languages. Ship more later.

**MAJORITY RULING**: Inline JSON translations in index.html. `t()` function wrapping all UI strings. 10 languages. Language selector in settings. RTL for Arabic. localStorage persistence.

---

## Feature 3: Split Windows for Multi-Agent Operations

### Auron
- **Proposal**: Add a "split" button to the header. Creates a second chat column with its own session ID, model selection, and message history. Each pane gets independent `/api/chat` calls. Max 4 panes.
- **Concerns**: Each pane needs its own SSE connection and session state. Backend already supports multiple sessions — just need unique session IDs per pane. Memory/CPU usage scales linearly.
- **Vote**: Independent panes with separate sessions, same backend.

### Lulu
- **Proposal**: Horizontal split (side-by-side). Each pane is a full chat-col clone: header mini-bar, messages, input area. Draggable divider between panes. Each pane shows which model it's using. Color-code panes by accent theme.
- **Concerns**: On small screens, max 2 panes. Mobile: stack vertically. Pane headers should be compact (no full header bar per pane).
- **Vote**: Side-by-side split, max 3 panes, compact pane headers, draggable dividers.

### Wakka
- **Proposal**: Architect as a "pane" system. Array of pane objects, each with: id, sessionId, model, provider, messages DOM ref. Central state manager. When user sends a message, it goes to the active pane's session.
- **Vote**: Pane array architecture. Each pane is self-contained.

### Kimahri
- **Proposal**: Simple 2-pane split. One button. No drag. Even 50/50 split.
- **Vote**: Start simple, iterate.

**MAJORITY RULING**: Pane system with array of pane objects. Draggable divider. Max 3 panes. Each pane has own session/model selector. Compact pane headers. Side-by-side horizontal layout.

---

## Implementation Order
1. i18n (foundation for all UI text) — touches index.html CSS+JS
2. Split windows (new UI capability) — touches index.html HTML+CSS+JS, main.rs minor
3. Installers (packaging) — new files, touches install_gui.py

## Version
v2.2.0 — "Polyglot Multi-Agent"
