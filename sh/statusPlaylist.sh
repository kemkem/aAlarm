#!/bin/sh

PID_PATH=/home/kemkem/Work/arduinoAlarm/sh

if [ -f $PID_PATH/mpg123.pid ];then
	PID=`/bin/cat $PID_PATH/mpg123.pid`
	PROCESS_COUNT=`ps -ef | grep -v grep | grep mpg123 | grep $PID | wc -l`
	if [ $PROCESS_COUNT > 0 ];then
		echo "Music playlist is running"
	else
		echo "Music playlist is not running"
	fi
else
	echo "Music playlist is not running"
fi


