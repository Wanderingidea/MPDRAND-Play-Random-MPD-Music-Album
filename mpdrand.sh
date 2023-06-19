#!/bin/bash

RNDDEV="/dev/ttyUSB0"
MUSICDIR="$HOME/Muziek"

ls $RNDDEV >/dev/null 2>&1 || exit 1
ls $MUSICDIR >/dev/null 2>&1 || exit 1

pidof -q mpd || mpd

mpc consume off >/dev/null
mpc random off >/dev/null
mpc repeat off >/dev/null

ALBUMS=`mpc list album`
NUM_ALBUMS=`echo "$ALBUMS" | wc -l`

RAND=`od -vAn -N2 -tu2 < $RNDDEV | tr -d ' \n\r'`

LINE=`expr $RAND % $NUM_ALBUMS`
ALBUM=`echo "$ALBUMS" | head -$LINE | tail -1`

mpc clear >/dev/null && mpc findadd album "$ALBUM" && mpc -q play 1

PAD=`mpc current -f %file%`
DN2=`echo "$PAD" | sed -r 's/\/track[1..9]*.*//'`
DN=`dirname "$DN2"`
IC=`find "$MUSICDIR/$DN" -type f -regex "^.*\.\(PNG\|JPG\|JPEG\|png\|jpg\|jpeg\)$" | sort | head -1`
notify-send -t 10000 -i "$IC"  "MPD `mpc status | sed -n '2p'`" "`mpc current | tr -d '\n\r'`" &


