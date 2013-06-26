#!/bin/sh

. $AALARM_PATH_FOLDER_CONFIG/config.sh

$PATH_CONTROLLER &
echo $! > $PATH_FOLDER_PID/controller.pid

$PATH_DJANGO_MANAGER runserver 0.0.0.0:8000 &
echo $! > $PATH_FOLDER_PID/django.pid

