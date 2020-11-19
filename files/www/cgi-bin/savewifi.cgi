#!/bin/sh

DATA_PATH="/www/data"

echo "Content-type: text/plain"
echo ""

# Save the old internal field separator.
  OIFS="$IFS"

# Set the field separator to & and parse the QUERY_STRING at the ampersand.
  IFS="${IFS}&"
  set $QUERY_STRING
  Args="$*"
  IFS="$OIFS"

# Next parse the individual "name=value" tokens.

  ARG_VAR=""
  ARG_SSID=""
  ARG_PSK=""

  for i in $Args ;do

#       Set the field separator to =
        IFS="${OIFS}="
        set $i
        IFS="${OIFS}"

        case $1 in
                # Don't allow "/" changed to " ". Prevent hacker problems.
                var) ARG_VAR="`echo -n $2 | sed 's|[\]||g' | sed 's|%20| |g'`"
                       ;;
                #
                ssid) ARG_SSID=$(echo -e `echo $2 | sed 's/+/ /g;s/%/\\\\x/g;'`)
                       ;;
                psw) ARG_PSK=$(echo -e `echo $2 | sed 's/+/ /g;s/%/\\\\x/g;'`)
                       ;;
                *)     echo "<hr>Warning:"\
                            "<br>Unrecognized variable \'$1\' passed.<hr>"
                       ;;

        esac
  done

# Set value

echo "#!/bin/sh" > /tmp/setwifi.sh

echo "uci set wireless.@wifi-device[0].channel=auto" >> /tmp/setwifi.sh
echo "uci set wireless.@wifi-device[0].disabled=0" >> /tmp/setwifi.sh
echo "uci set wireless.@wifi-device[0].country=RU" >> /tmp/setwifi.sh
echo "uci set wireless.@wifi-iface[0]=wifi-iface" >> /tmp/setwifi.sh
echo "uci set wireless.@wifi-iface[0].device=radio0" >> /tmp/setwifi.sh
echo "uci set network.wwan=interface" >> /tmp/setwifi.sh
echo "uci set network.wwan.dns=8.8.8.8" >> /tmp/setwifi.sh
echo "uci set network.wwan.proto=dhcp" >> /tmp/setwifi.sh

echo "uci set wireless.@wifi-iface[0].mode=sta" >> /tmp/setwifi.sh
echo "uci set wireless.@wifi-iface[0].network=wwan" >> /tmp/setwifi.sh
echo "uci set wireless.@wifi-iface[0].ssid='$ARG_SSID'" >> /tmp/setwifi.sh
echo "uci set wireless.@wifi-iface[0].encryption='psk2'" >> /tmp/setwifi.sh
echo "uci set wireless.@wifi-iface[0].key='$ARG_PSK'" >> /tmp/setwifi.sh
echo "uci commit network" >> /tmp/setwifi.sh
echo "uci commit wireless; wifi" >> /tmp/setwifi.sh
echo "wifi down" >> /tmp/setwifi.sh

echo "/etc/init.d/network restart" >> /tmp/setwifi.sh
echo "wifi up" >> /tmp/setwifi.sh

`chmod +x /tmp/setwifi.sh`
#`/tmp/setwifi.sh &`


echo
echo "Saved"