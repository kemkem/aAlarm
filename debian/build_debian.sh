#!/bin/bash

mkdir -p aalarm_package/usr/share/aalarm
mkdir -p aalarm_package/usr/bin
mkdir -p aalarm_package/etc/aalarm

cp ../sh/* aalarm_package/usr/bin
cp -R ../conf/* aalarm_package/etc/aalarm
cp -R ../pl aalarm_package/usr/share/aalarm
cp -R ../webDj aalarm_package/usr/share/aalarm

chmod 755 aalarm_package/DEBIAN/*

dpkg --build aalarm_package
