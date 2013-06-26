#!/bin/sh

. $AALARM_PATH_FOLDER_CONFIG/config.sh

if [ -f $PATH_FOLDER_PID/controller.pid ];then
	PID=`/bin/cat $PATH_FOLDER_PID/controller.pid`
	/bin/kill -9 $PID
	rm $PATH_FOLDER_PID/controller.pid
else
	echo "no pid found. controller is not running."
fi

if [ -f $PATH_FOLDER_PID/django.pid ];then
	PID=`/bin/cat $PATH_FOLDER_PID/django.pid`
	/usr/bin/pkill -9 $PID
	rm $PATH_FOLDER_PID/django.pid
else
	echo "no pid found. django is not running."
fi

$PATH_FOLDER_SCRIPTS/stopPlaylist.sh
$PATH_FOLDER_SCRIPTS/stopZM.sh
