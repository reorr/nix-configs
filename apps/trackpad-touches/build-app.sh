#!/bin/bash
# Build TrackpadTouches.app (no Xcode project needed).
set -euo pipefail

cd "$(dirname "$0")"

swift build -c release

APP="TrackpadTouches.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"
cp .build/release/TrackpadTouches "$APP/Contents/MacOS/TrackpadTouches"

cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>TrackpadTouches</string>
    <key>CFBundleIdentifier</key>
    <string>local.trackpad-touches</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>Trackpad Touches</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>14.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
PLIST

echo "Built $PWD/$APP"
