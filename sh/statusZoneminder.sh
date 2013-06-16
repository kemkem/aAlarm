#!/bin/sh

if ps ax | grep -v grep | grep zmwatch.pl > /dev/null
then
	echo "Zoneminder is running"
else
	echo "Zoneminder is stopped"
fi

