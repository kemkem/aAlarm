#!/bin/bash

cp ../sh aalarm_package/usr/bin

mkdir -p aalarm_package/usr/share/aAlarm
mkdir -p aalarm_package/usr/bin

cp -R ../conf aalarm_package/usr/share/aAlarm
cp -R ../pl aalarm_package/usr/share/aAlarm
cp -R ../webDj aalarm_package/usr/share/aAlarm

dpkg --build aalarm_package