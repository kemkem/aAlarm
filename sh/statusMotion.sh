#!/bin/sh

if ps ax | grep -v grep | grep motion > /dev/null
then
	echo "Motion is running"
else
	echo "Motion is stopped"
fi

