#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
echo "=== Amni-Code Package Builder ==="
echo "Building release binary..."
cd "$PROJECT_ROOT"
cargo build --release
OS="$(uname -s)"
case "$OS" in
  Darwin)
    echo "Building macOS DMG..."
    bash "$SCRIPT_DIR/macos/build-dmg.sh"
    ;;
  Linux)
    echo "Building Linux .deb..."
    bash "$SCRIPT_DIR/linux/build-deb.sh"
    ;;
  MINGW*|MSYS*|CYGWIN*)
    echo "Windows: Use WiX toolset to build MSI from packaging/windows/amni-code.wxs"
    echo "  candle.exe packaging\\windows\\amni-code.wxs -o build\\amni-code.wixobj"
    echo "  light.exe -ext WixUIExtension -ext WixUtilExtension build\\amni-code.wixobj -o build\\AmniCode-2.2.0.msi"
    ;;
  *)
    echo "Unknown OS: $OS"
    exit 1
    ;;
esac
echo "Done."
