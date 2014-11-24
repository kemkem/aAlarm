#!/bin/bash

mkdir -p aalarm_package/usr/share/aAlarm
mkdir -p aalarm_package/usr/bin

cp -R ../sh aalarm_package/usr/bin
cp -R ../conf aalarm_package/usr/share/aAlarm
cp -R ../pl aalarm_package/usr/share/aAlarm
cp -R ../webDj aalarm_package/usr/share/aAlarm

chmod 755 aalarm_package/DEBIAN/*

dpkg --build aalarm_package
