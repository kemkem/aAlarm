#!/bin/sh

. $AALARM_PATH_FOLDER_CONFIG/config.sh

killall alarmSerialController.pl
killall manage.py
$PATH_FOLDER_SCRIPTS/stopPlaylist.sh
$PATH_FOLDER_SCRIPTS/stopZM.sh

