#!/bin/ash

wifi_ap_mode()
{
	ifconfig wlan0 down
	/etc/init.d/dnsmasq stop
	killall wpa_supplicant hostapd  dnsmasq
	ifconfig wlan0 up

	ifconfig wlan0 192.168.0.1 netmask 255.255.255.0
	iw dev wlan0 scan | grep SSID > /www/ssidlist.i
	dnsmasq --conf-file=/etc/dnsmasq.conf
	mkdir -p /var/run/hostapd
	hostapd /etc/hostapd.conf &
}

wifi_sta_mode()
{
	killall wpa_supplicant hostapd  dnsmasq
	wpa_supplicant -iwlan0 -B -c/etc/wpa_supplicant.conf &
	udhcpc -i wlan0 &
	sed -i -e 's/127.0.0.1/8.8.8.8/g' /etc/resolv.conf
}

start()
{
    if [ -e /etc/wpa_supplicant.conf ]; then
	wifi_sta_mode
    else
	wifi_ap_mode
    fi
}

start
