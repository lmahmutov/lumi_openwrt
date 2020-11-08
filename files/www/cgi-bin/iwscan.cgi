#!/bin/sh
echo "Content-type: text/html"
echo ""
echo "<html><head><title>Xiaomi gateway"
echo "</title></head><body>"
echo "<pre> $(iw dev wlan0 scan ap-force | grep SSID) </pre>"

echo "</body></html>"