#!/bin/sh

echo "Content-type: text/html; charset=utf-8"
echo


ret=$(ps | grep iw | wc -l)
if [ "$ret" -eq 1 ]; then
    exit
fi

if [ -f /tmp/iwscan.txt ]; then
    echo "$(cat /tmp/iwscan.txt)"
    rm /tmp/iwscan.txt
    exit
fi

`iw dev wlan0 scan ap-force | grep SSID > /tmp/iwscan.txt &`
