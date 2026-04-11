#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
APP_NAME="Amni-Code"
VERSION="2.2.0"
BINARY="$PROJECT_ROOT/target/release/amni"
DMG_NAME="${APP_NAME}-${VERSION}.dmg"
APP_BUNDLE="$SCRIPT_DIR/build/${APP_NAME}.app"
if [ ! -f "$BINARY" ]; then
  echo "ERROR: Binary not found at $BINARY"
  echo "Run 'cargo build --release' first."
  exit 1
fi
rm -rf "$SCRIPT_DIR/build"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"
cat > "$APP_BUNDLE/Contents/Info.plist" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key><string>${APP_NAME}</string>
  <key>CFBundleDisplayName</key><string>${APP_NAME}</string>
  <key>CFBundleIdentifier</key><string>com.amni.amni-code</string>
  <key>CFBundleVersion</key><string>${VERSION}</string>
  <key>CFBundleShortVersionString</key><string>${VERSION}</string>
  <key>CFBundleExecutable</key><string>amni</string>
  <key>CFBundleIconFile</key><string>icon.icns</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>LSMinimumSystemVersion</key><string>11.0</string>
  <key>NSHighResolutionCapable</key><true/>
</dict>
</plist>
PLIST
cp "$BINARY" "$APP_BUNDLE/Contents/MacOS/amni"
chmod +x "$APP_BUNDLE/Contents/MacOS/amni"
if [ -f "$PROJECT_ROOT/static/icon.icns" ]; then
  cp "$PROJECT_ROOT/static/icon.icns" "$APP_BUNDLE/Contents/Resources/icon.icns"
fi
DMG_TMP="$SCRIPT_DIR/build/dmg-staging"
mkdir -p "$DMG_TMP"
cp -R "$APP_BUNDLE" "$DMG_TMP/"
ln -s /Applications "$DMG_TMP/Applications"
hdiutil create -volname "$APP_NAME" \
  -srcfolder "$DMG_TMP" \
  -ov -format UDZO \
  "$SCRIPT_DIR/build/$DMG_NAME"
rm -rf "$DMG_TMP"
echo "DMG created: $SCRIPT_DIR/build/$DMG_NAME"
cat << 'SETUP'
Post-install: Users can optionally add to PATH:
  sudo ln -sf /Applications/Amni-Code.app/Contents/MacOS/amni /usr/local/bin/amni
SETUP
