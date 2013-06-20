#!/bin/sh

PATH_SOURCE="/usr/share/zoneminder/events/Door"
PATH_TARGET="/home/kemkem/Work/djangoAAlarm/static/img/zmlast"

rm $PATH_TARGET/*
find $PATH_SOURCE/ -cmin -5 -exec cp {} $PATH_TARGET \;
find $PATH_TARGET -name '*analyse*jpg' -exec rm {} \;
find $PATH_TARGET -name '*jpg' > $PATH_TARGET/list


