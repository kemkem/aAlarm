#!/bin/sh

. $AALARM_PATH_FOLDER_CONFIG/config.sh

cd $AALARM_PATH_FOLDER_CONFIG/../pl
$PATH_CONTROLLER > /dev/null 2>&1 &
echo $! > $PATH_FOLDER_PID/controller.pid

$PATH_DJANGO_MANAGER runserver 0.0.0.0:8000 > /dev/null 2>&1 &
echo $! > $PATH_FOLDER_PID/django.pid

