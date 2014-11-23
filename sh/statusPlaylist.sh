#!/bin/sh

. AALARM_PATH_FOLDER_CONFIG/config.sh

if [ -f $PATH_FOLDER_PID/mpg123.pid ];then
	PID=`/bin/cat $PATH_FOLDER_PID/mpg123.pid`
    if ps ax | grep -v grep | grep mpg123 | grep $PID > /dev/null
    then
		echo "Music playlist is running"
	else
		echo "Music playlist is stopped"
	fi
else
	echo "Music playlist is stopped"
fi


