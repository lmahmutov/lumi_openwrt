#!/bin/sh
# Domoticz installer script

cd /tmp/
echo "Download files"
wget https://github.com/lmahmutov/lumi_packages/raw/main/domoticz_2020.2-3_arm_cortex-a9_neon.ipk
wget https://github.com/lmahmutov/lumi_packages/raw/main/liblua5.3-5.3_5.3.5-4_arm_cortex-a9_neon.ipk
wget https://github.com/lmahmutov/lumi_packages/raw/main/lua5.3_5.3.5-4_arm_cortex-a9_neon.ipk
wget https://github.com/lmahmutov/lumi_packages/raw/main/shadow-usermod_4.8.1-1_arm_cortex-a9_neon.ipk

echo "start installation"
opkg update
opkg install /tmp/liblua5.3-5.3_5.3.5-4_arm_cortex-a9_neon.ipk
opkg install /tmp/lua5.3_5.3.5-4_arm_cortex-a9_neon.ipk
opkg install /tmp/domoticz_2020.2-3_arm_cortex-a9_neon.ipk
opkg install /tmp/shadow-usermod_4.8.1-1_arm_cortex-a9_neon.ipk

usermod -a -G audio domoticz
usermod -a -G dialout domoticz

echo "Add plugin"
cd /etc/domoticz/plugins/
DIR="Domoticz-Zigate"
if [ -d "$DIR" ]; then
  # Take action if $DIR exists. #
  echo "previous installation find remove it"
  rm -r /etc/domoticz/plugins/Domoticz-Zigate
fi
git clone https://github.com/pipiche38/Domoticz-Zigate.git
chmod +x Domoticz-Zigate/plugin.py

echo "Moving files and download domoticz config"

cd /tmp/
mv /var/lib/domoticz/domoticz.db /etc/domoticz/domoticz.db
mv /var/lib/domoticz/domoticz.db-shm /etc/domoticz/domoticz.db-shm
mv /var/lib/domoticz/domoticz.db-wal /etc/domoticz/domoticz.db-wal

wget https://github.com/lmahmutov/lumi_packages/raw/main/domoticz_etc
wget https://github.com/lmahmutov/lumi_packages/raw/main/domoticz_init

mv /tmp/domoticz_init /etc/init.d/domoticz
chmod 755 /etc/init.d/domoticz
mv /tmp/domoticz_etc /etc/config/domoticz
chmod 600 /etc/config/domoticz


chown -R domoticz:domoticz /etc/domoticz
echo "Installation complete, reboot"
reboot
