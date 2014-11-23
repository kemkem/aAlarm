#!/bin/sh

. AALARM_PATH_FOLDER_CONFIG/config.sh

if [ -f $PATH_FOLDER_PID/mpg123.pid ];then
	PID=`/bin/cat $PATH_FOLDER_PID/mpg123.pid`
	/bin/kill -9 $PID
	rm $PATH_FOLDER_PID/mpg123.pid
else
	echo "no pid found. mpg123 is not running."
fi

