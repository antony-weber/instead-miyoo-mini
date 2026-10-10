#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build_miyoo"
PKG_DIR="${SCRIPT_DIR}/package"
OUTPUT_ZIP="${SCRIPT_DIR}/INSTEAD-OnionOS.zip"

echo "=== Assembling OnionOS Emulator Package ==="

# 1. Check for compiled binary
BINARY="${BUILD_DIR}/src/sdl-instead"
if [ ! -f "$BINARY" ]; then
    echo "Error: $BINARY not found. Build the project first."
    exit 1
fi

rm -rf "$PKG_DIR" "$OUTPUT_ZIP"
mkdir -p "${PKG_DIR}/Emu/INSTEAD/bin"
mkdir -p "${PKG_DIR}/Emu/INSTEAD/lib"
mkdir -p "${PKG_DIR}/Icons/Default"
mkdir -p "${PKG_DIR}/Roms/INSTEAD/Imgs"

# 2. Strip and install binary
if command -v arm-linux-gnueabihf-strip >/dev/null 2>&1; then
    arm-linux-gnueabihf-strip "$BINARY" -o "${PKG_DIR}/Emu/INSTEAD/bin/instead"
else
    strip "$BINARY" -o "${PKG_DIR}/Emu/INSTEAD/bin/instead" 2>/dev/null || cp "$BINARY" "${PKG_DIR}/Emu/INSTEAD/bin/instead"
fi
chmod +x "${PKG_DIR}/Emu/INSTEAD/bin/instead"

# 3. Copy runtime shared libraries
if [ -d "${SCRIPT_DIR}/runtime_libs" ]; then
    cp -P "${SCRIPT_DIR}/runtime_libs"/*.so* "${PKG_DIR}/Emu/INSTEAD/lib/"
fi

# 4. Copy fresh stead, themes, and lang directly from repository root
cp -r "${SCRIPT_DIR}/stead" "${PKG_DIR}/Emu/INSTEAD/"
cp -r "${SCRIPT_DIR}/themes" "${PKG_DIR}/Emu/INSTEAD/"
cp -r "${SCRIPT_DIR}/lang" "${PKG_DIR}/Emu/INSTEAD/"

# 5. Copy launcher scripts, metadata and assets
cp "${SCRIPT_DIR}/onion_emu/config.json" "${PKG_DIR}/Emu/INSTEAD/"
cp "${SCRIPT_DIR}/onion_emu/launch.sh" "${PKG_DIR}/Emu/INSTEAD/"
cp "${SCRIPT_DIR}/onion_emu/generate_gamelist.py" "${PKG_DIR}/Emu/INSTEAD/"
cp "${SCRIPT_DIR}/onion_emu/bg.png" "${PKG_DIR}/Emu/INSTEAD/"
cp "${SCRIPT_DIR}/onion_emu/icon.png" "${PKG_DIR}/Emu/INSTEAD/"
cp "${SCRIPT_DIR}/onion_emu/icon-f.png" "${PKG_DIR}/Emu/INSTEAD/"
cp "${SCRIPT_DIR}/onion_emu/default_cover.png" "${PKG_DIR}/Emu/INSTEAD/"
chmod +x "${PKG_DIR}/Emu/INSTEAD/launch.sh" "${PKG_DIR}/Emu/INSTEAD/generate_gamelist.py"

# 6. Copy system carousel icon
cp "${SCRIPT_DIR}/onion_emu/icon.png" "${PKG_DIR}/Icons/Default/instead.png"

# 7. Create distributable zip archive
cd "$PKG_DIR"
zip -r "$OUTPUT_ZIP" Emu/ Icons/ Roms/
cd "$SCRIPT_DIR"

echo "=== Package created successfully: $OUTPUT_ZIP ==="
