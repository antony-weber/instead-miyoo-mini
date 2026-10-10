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

# 5. GameSwitcher Screenshot Fallback Hook
SCREENSHOT_PATH="/tmp/screenshot.png"
if [ ! -s "$SCREENSHOT_PATH" ]; then
	echo "[launch.sh] /tmp/screenshot.png missing or empty, applying fallback..." >> "$LOG_FILE"
	FALLBACK_FOUND=0

	# 1. Попытка взять индивидуальный боксарт квеста
	if [ -n "$1" ]; then
		QUEST_FILENAME="$(basename "$1")"
		QUEST_NAME="${QUEST_FILENAME%.*}"
		QUEST_IMG="$ROMS_DIR/Imgs/$QUEST_NAME.png"

		if [ -f "$QUEST_IMG" ]; then
			cp "$QUEST_IMG" "$SCREENSHOT_PATH"
			FALLBACK_FOUND=1
			echo "[launch.sh] Fallback to quest boxart: $QUEST_IMG" >> "$LOG_FILE"
		fi
	fi

	# 2. Если обложки квеста нет — системный полноэкранный арт эмулятора (640x480)
	if [ $FALLBACK_FOUND -eq 0 ] && [ -f "$EMU_DIR/bg.png" ]; then
		cp "$EMU_DIR/bg.png" "$SCREENSHOT_PATH"
		FALLBACK_FOUND=1
		echo "[launch.sh] Fallback to emulator background: $EMU_DIR/bg.png" >> "$LOG_FILE"
	fi

	# 3. Дефолтная заглушка обложки
	if [ $FALLBACK_FOUND -eq 0 ] && [ -f "$EMU_DIR/default_cover.png" ]; then
		cp "$EMU_DIR/default_cover.png" "$SCREENSHOT_PATH"
		FALLBACK_FOUND=1
		echo "[launch.sh] Fallback to default cover: $EMU_DIR/default_cover.png" >> "$LOG_FILE"
	fi

	# 4. Финальный аварийный фоллбэк на иконку
	if [ $FALLBACK_FOUND -eq 0 ] && [ -f "$EMU_DIR/icon.png" ]; then
		cp "$EMU_DIR/icon.png" "$SCREENSHOT_PATH"
		echo "[launch.sh] Fallback to icon: $EMU_DIR/icon.png" >> "$LOG_FILE"
	fi
fi

# Also synchronize screenshot to OnionOS romScreens cache if a ROM was launched
if [ -s "$SCREENSHOT_PATH" ] && [ -n "$1" ]; then
	QUEST_FILENAME="$(basename "$1")"
	QUEST_NAME="${QUEST_FILENAME%.*}"
	ROMSCREENS_DIR="$SDCARD_DIR/Saves/CurrentProfile/romScreens"
	if [ -d "$ROMSCREENS_DIR" ]; then
		# If individual quest boxart exists, ensure it matches romScreens cache
		if [ -f "$ROMS_DIR/Imgs/$QUEST_NAME.png" ]; then
			echo "[launch.sh] Preserving quest preview for GameSwitcher" >> "$LOG_FILE"
		fi
	fi
fi

# 6. Flush filesystem buffers
sync
exit $EXIT_CODE
