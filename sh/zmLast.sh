#!/bin/sh

. $AALARM_PATH_FOLDER_CONFIG/config.sh

#TODO maybe init this directory in some install script
mkdir -p $PATH_ZM_TARGET
rm $PATH_ZM_TARGET/*
find $PATH_ZM_SOURCE/ -cmin -5 -exec cp {} $PATH_ZM_TARGET \;
find $PATH_ZM_TARGET -name '*analyse*jpg' -exec rm {} \;
find $PATH_ZM_TARGET -name '*jpg' > $PATH_ZM_TARGET/list


