#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PKG_NAME="amni-code"
VERSION="2.2.0"
ARCH="amd64"
BINARY="$PROJECT_ROOT/target/release/amni"
DEB_DIR="$SCRIPT_DIR/build/${PKG_NAME}_${VERSION}_${ARCH}"
if [ ! -f "$BINARY" ]; then
  echo "ERROR: Binary not found at $BINARY"
  echo "Run 'cargo build --release' first."
  exit 1
fi
rm -rf "$SCRIPT_DIR/build"
mkdir -p "$DEB_DIR/DEBIAN"
mkdir -p "$DEB_DIR/usr/local/bin"
mkdir -p "$DEB_DIR/usr/share/applications"
mkdir -p "$DEB_DIR/usr/share/icons/hicolor/256x256/apps"
cat > "$DEB_DIR/DEBIAN/control" << CTRL
Package: ${PKG_NAME}
Version: ${VERSION}
Section: devel
Priority: optional
Architecture: ${ARCH}
Maintainer: Amni <contact@amni.dev>
Description: Amni-Code AI Coding Agent
 Self-hosted AI coding agent with full embedded IDE,
 multi-model support, i18n, and split-pane workflows.
Homepage: https://github.com/amni/amni-code
CTRL
cp "$BINARY" "$DEB_DIR/usr/local/bin/amni"
chmod 755 "$DEB_DIR/usr/local/bin/amni"
cat > "$DEB_DIR/usr/share/applications/amni-code.desktop" << DESKTOP
[Desktop Entry]
Name=Amni-Code
Comment=AI Coding Agent
Exec=/usr/local/bin/amni
Terminal=false
Type=Application
Categories=Development;IDE;
Icon=amni-code
DESKTOP
if [ -f "$PROJECT_ROOT/static/icon.png" ]; then
  cp "$PROJECT_ROOT/static/icon.png" "$DEB_DIR/usr/share/icons/hicolor/256x256/apps/amni-code.png"
fi
cat > "$DEB_DIR/DEBIAN/postinst" << 'POST'
#!/bin/bash
echo "Amni-Code installed. Run 'amni' from terminal or find it in your application menu."
POST
chmod 755 "$DEB_DIR/DEBIAN/postinst"
dpkg-deb --build "$DEB_DIR"
echo "DEB created: ${DEB_DIR}.deb"
