#!/bin/sh
cd "$(dirname "$0")"
progdir="$(pwd)"
miyoodir="/mnt/SDCARD/miyoo"

export SDL_VIDEODRIVER=mmiyoo
export EGL_VIDEODRIVER=mmiyoo
export SDL_AUDIODRIVER=dsp

export LD_LIBRARY_PATH="$progdir/libs:$miyoodir/lib:$LD_LIBRARY_PATH"

if [ -f "$miyoodir/lib/libpadsp.so" ]; then
	export LD_PRELOAD="$progdir/libs/libEGL.so:$progdir/libs/libSDL2-2.0.so.0:$miyoodir/lib/libpadsp.so"
else
	export LD_PRELOAD="$progdir/libs/libEGL.so:$progdir/libs/libSDL2-2.0.so.0"
fi

echo "=== INSTEAD LAUNCH ===" >> ./instead.log
date >> ./instead.log
./sdl-instead -appdata "$progdir/appdata" -nohires -gamespath "$progdir/games" "$@" >> ./instead.log 2>&1
echo "EXIT CODE: $?" >> ./instead.log
sync
