#!/bin/sh

. $AALARM_PATH_FOLDER_CONFIG/config.sh

if [ -f $PATH_FOLDER_PID/mpg123.pid ];then
	echo "pid present : mpg123 already running"
	exit 0
else
	/usr/bin/mpg123 -@ $PATH_PLAYLIST -Z > /dev/null 2>&1 &
	echo $! > $PATH_FOLDER_PID/mpg123.pid 
fi

