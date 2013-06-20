#!/bin/sh

PID_PATH=/home/kemkem/Work/arduinoAlarm/sh

if [ -f $PID_PATH/mpg123.pid ];then
	PID=`/bin/cat $PID_PATH/mpg123.pid`
    if ps ax | grep -v grep | grep mpg123 | grep $PID > /dev/null
    then
		echo "Music playlist is running"
	else
		echo "Music playlist is stopped"
	fi
else
	echo "Music playlist is stopped"
fi


