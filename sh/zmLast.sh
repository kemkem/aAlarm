#!/bin/sh

rm /home/kemkem/aalarm/web/zmlast/*
find /usr/share/zoneminder/events/Door/ -cmin -5 -exec cp {} /home/kemkem/aalarm/web/zmlast \;
rm /home/kemkem/aalarm/web/zmlast/*analyse*.jpg
echo "<html><head><title></title></head><body>" > /home/kemkem/aalarm/web/zmlast/index.prepare
echo "<p>Last Event @" >> /home/kemkem/aalarm/web/zmlast/index.prepare
date >> /home/kemkem/aalarm/web/zmlast/index.prepare
echo "</p>" >>/home/kemkem/aalarm/web/zmlast/index.prepare
#find /home/kemkem/aalarm/web/zmlast/ -exec echo "<p><img src=\""{}"\"></p>" \; >> /home/kemkem/aalarm/web/zmlast/index.prepare

for item in `ls /home/kemkem/aalarm/web/zmlast/`;
do 
echo "<p><img src=\"$item\"></p>" >> /home/kemkem/aalarm/web/zmlast/index.prepare
done

echo "</body></html>" >> /home/kemkem/aalarm/web/zmlast/index.prepare
sed 's/\/home\/kemkem\/aalarm\/web\/zmlast\///' /home/kemkem/aalarm/web/zmlast/index.prepare > /home/kemkem/aalarm/web/zmlast/index.html
