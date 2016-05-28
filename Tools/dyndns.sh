#!/bin/bash
# Esamatti Käkelä <ekakela@gmail.com> 11.05.2016
# Tool for automatically updating joker.com DDNS entries 
#
# Required variables 
HOST="Insert hostname here" #HOST to check for
USER="USERNAME" #DDNS username
PASS="PASSWORd" #DDNS password
# ----------------------------------------------------------- #

CURIP=$(curl -4 -s ip.nebula.fi | tail -1 | awk {'print $1'})
NSIP=$(dig $HOST @A.NS.Joker.COM | grep -A1 "ANSWER SECTION" | tail -1 | awk {'print $5'})
echo $NSIP

if [ "$CURIP" == "$NSIP" ];then
	exit 0
else
	#Update the DDNS entry
	curl -s -4 http://svc.joker.com/nic/update?username=$USER&password=$PASS&hostname=$HOST
fi
