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
                ssid) ARG_SSID=$2
                       ;;
                psw) ARG_PSK=$2
                       ;;
                *)     echo "<hr>Warning:"\
                            "<br>Unrecognized variable \'$1\' passed.<hr>"
                       ;;

        esac
  done

# Set value
echo "" > /etc/wpa_supplicant.conf
echo "network={" >> /etc/wpa_supplicant.conf
echo "	ssid=\"$ARG_SSID\"" >> /etc/wpa_supplicant.conf
echo "	psk=\"$ARG_PSK\"" >> /etc/wpa_supplicant.conf
echo "}" >> /etc/wpa_supplicant.conf
echo