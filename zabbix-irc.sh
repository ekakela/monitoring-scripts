#!/bin/bash
# This script is used to forward Zabbix-alerts to IRC via socat / irssi
# Esamatti Käkelä 2015-08-13
# $1 is the address in zabbix media-field
# $2 is subject (not used atm)
# $3 is the message itself 

#Necessary defines
to="/opt/irssi/irssi.sock" # change this to $2 if you want to change the socket used via zabbix media-configuration 
msg=$3

# Colorizing output 
msg=$(echo -e "$msg" | sed -e 's/ALERT/\\00034ALERT\\03/g')
msg=$(echo -e "$msg" | sed -e 's/RECOVERY/\\00033RECOVERY\\03/g')
msg=$(echo -e "$msg" | sed -e 's/Disaster/\\00034Disaster\\03/g')
msg=$(echo -e "$msg" | sed -e 's/High/\\00037High\\03/g')
msg=$(echo -e "$msg" | sed -e 's/Average/\\00038Average\\03/g')
msg=$(echo -e "$msg" | sed -e 's/Warning/\\000310Warning\\03/g')
msg=$(echo -e "$msg" | sed -e 's/Information/\\00030Information\\03/g')
msg=$(echo -e "$msg" | sed -e 's/CRON/\\000313CRON\\03/g')

# Pushing the modified message to socket
echo -e $(echo "$msg")  | socat - UNIX-CONNECT:"$to" >/dev/null 2>&1
