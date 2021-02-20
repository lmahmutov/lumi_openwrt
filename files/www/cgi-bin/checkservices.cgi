#!/bin/sh

echo "Content-type: text/html; charset=utf-8"
echo


ret=$(ps | grep node-red | wc -l)
if [ "$ret" -eq 2 ]; then
    echo "<a href='http://$SERVER_NAME:1880'>Node-Red</a><br>"
fi

#if [ -f /root/.homeassistant/home-assistant.log ]; then
ret=$(ps | grep hass | wc -l)
if [ "$ret" -eq 2 ]; then
    echo "<a href='http://$SERVER_NAME:8123'>Home Assistant</a><br>"
fi

ret=$(ps | grep zigbee2mqtt | wc -l)
if [ "$ret" -eq 2 ]; then
    echo "<a href='http://$SERVER_NAME:8080'>Zigbee2Mqtt</a><br>"
fi

ret=$(ps | grep luci | wc -l)
if [ "$ret" -eq 2 ]; then
    echo '<a href="/luci/">Luci</a><br>'
fi

if [ -f /www/snapweb/index.html ]; then
    echo "<a href='http://$SERVER_NAME:1780'>SnapWeb</a><br>"
fi

exit 0