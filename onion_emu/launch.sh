#!/bin/sh
# OnionOS / RedOnion Emu integration launch script for INSTEAD

# 1. Resolve runtime directories relatives to script location
EMU_DIR="$(cd "$(dirname "$0")" && pwd)"
SDCARD_DIR="$(cd "$EMU_DIR/../.." && pwd)"

SAVES_DIR="$SDCARD_DIR/Saves/CurrentProfile/saves/INSTEAD"
ROMS_DIR="$SDCARD_DIR/Roms/INSTEAD"
MIYOO_DIR="$SDCARD_DIR/miyoo"

# 2. Ensure isolated save and rom directories exist
mkdir -p "$SAVES_DIR"
mkdir -p "$ROMS_DIR"

# Copy default config if not initialized
if [ ! -f "$SAVES_DIR/insteadrc" ] && [ -f "$EMU_DIR/share/appdata/insteadrc" ]; then
	cp "$EMU_DIR/share/appdata/insteadrc" "$SAVES_DIR/insteadrc"
fi

# 3. Environment & Drivers for Miyoo Mini hardware
export SDL_VIDEODRIVER=mmiyoo
export EGL_VIDEODRIVER=mmiyoo
export SDL_AUDIODRIVER=dsp

export LD_LIBRARY_PATH="$EMU_DIR/lib:$MIYOO_DIR/lib:$LD_LIBRARY_PATH"

if [ -f "$MIYOO_DIR/lib/libpadsp.so" ]; then
	export LD_PRELOAD="$EMU_DIR/lib/libEGL.so:$EMU_DIR/lib/libSDL2-2.0.so.0:$MIYOO_DIR/lib/libpadsp.so"
else
	export LD_PRELOAD="$EMU_DIR/lib/libEGL.so:$EMU_DIR/lib/libSDL2-2.0.so.0"
fi

cd "$EMU_DIR"

LOG_FILE="$SAVES_DIR/instead.log"
echo "=== INSTEAD LAUNCH ===" >> "$LOG_FILE"
date >> "$LOG_FILE"
echo "Arg 1: $1" >> "$LOG_FILE"

# 4. Launch engine with quest ROM or into default mode
if [ -n "$1" ] && [ -f "$1" ]; then
	echo "Launching ROM: $1" >> "$LOG_FILE"
	"$EMU_DIR/bin/instead" \
		-standalone \
		-nohires \
		-appdata "$SAVES_DIR" \
		-themespath "$EMU_DIR/share/themes" \
		"$1" >> "$LOG_FILE" 2>&1
else
	echo "Launching default/fallback mode" >> "$LOG_FILE"
	"$EMU_DIR/bin/instead" \
		-standalone \
		-nohires \
		-appdata "$SAVES_DIR" \
		-gamespath "$ROMS_DIR" \
		-themespath "$EMU_DIR/share/themes" >> "$LOG_FILE" 2>&1
fi

EXIT_CODE=$?
echo "EXIT CODE: $EXIT_CODE" >> "$LOG_FILE"

# 5. Flush filesystem buffers
sync
exit $EXIT_CODE
