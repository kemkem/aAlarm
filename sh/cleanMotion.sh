#!/bin/sh

#. $AALARM_PATH_FOLDER_CONFIG/config.sh

#find $PATH_MOTION_TARGET/ -mtime +7 -exec rm -f {} \;
#TODO here we need to keep hardcoded dir...
find "PATH_AALARM/webDj/static/motion/" -mtime +7 -exec rm -f {} \;
