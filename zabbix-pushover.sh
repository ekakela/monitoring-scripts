#!/bin/bash
# Tool for pushing customized Zabbix alerts via pushover.net service
# Esamatti Käkelä <ekakela@gmail.com>

TOKEN=""
USER=""
BINARY=/opt/bin/pushover # Specify path to the jnwatts/pushover.sh 

TO=$1 #device name
SUBJECT=$2 # Used as title field in pushover message
BODY=$3 # the message itself

## Parsing priority from Zabbix message and modifying pushover parameters accordingly

PT=$(echo $2 | awk {'print $1'})
shopt -s nocasematch
case "$PT" in

critical)  #Priority to highest, overrides quiet hours set by pushover, retry every 180 seconds up to 3600 seconds if alarm not acknowledged, use Alien Alert sound
P="2 -r 180 -e 3600 -s alien"
;;

problem) # Priority 1, bit above normal. Use siren sound
P="1 -s siren"
;;

ok) # Use sound Magic for recovery events, do not bother user if quiet mode is on.
P="0 -s Magic"
;;

*) # All others will be sent with priority 0, configurable from device side
P="0"
;;
esac

## Sending data via jnwatts pushover bash script
## if TO = "all" send to all devices, otherwise send to the device specified in Zabbix media configuration for user

if [[ TO == "all" ]]; then
        $BINARY -T $TOKEN -U $USER -p $P -t "SUBJECT" "BODY"
else
        $BINARY -d $TO -T $TOKEN -U $USER -p $P -t "SUBJECT" "BODY"

