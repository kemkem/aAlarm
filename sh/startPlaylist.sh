#!/bin/sh

PID_PATH=/home/kemkem/Work/arduinoAlarm/sh
PLAYLIST_PATH="/home/kemkem/Electro/list"

if [ -f $PID_PATH/mpg123.pid ];then
	echo "pid present : mpg123 already running"
	exit 0
else
	/usr/bin/mpg123 -@ $PLAYLIST_PATH -Z > /dev/null 2>&1 &
	echo $! > $PID_PATH/mpg123.pid 
fi

