#!/bin/sh

PID_PATH=/home/kemkem/aalarmv2/arduinoAlarm/sh

if [ -f $PID_PATH/mpg123.pid ];then
	PID=`/bin/cat $PID_PATH/mpg123.pid`
	/bin/kill -9 $PID
	rm $PID_PATH/mpg123.pid
else
	echo "no pid found. mpg123 is not running."
fi

