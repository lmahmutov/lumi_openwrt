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

echo "Installation complete"
