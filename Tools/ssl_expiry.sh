#!/bin/bash
# Check days until SSL sertificate expiry for Zabbix
# Esamatti Käkelä <ekakela@gmail.com
#
# Define variables, note default ssl port is 443 unless otherwise specified
# Timeout added in case of openssl hanging or responsing slowly
HOST=$1
PORT=${2:-443}
TIMEOUT=25

#Check sertificate expirary date
edate="$(/usr/bin/timeout $TIMEOUT /usr/bin/openssl s_client -host $HOST -port $PORT -showcerts < /dev/null 2>/dev/null | sed -n '/BEGIN CERTIFICATE/,/END CERT/p' | openssl x509 -enddate -noout 2>/dev/null | sed -e 's/^.*\=//')"

echo $edate
#Format the date into seconds, compare to current time
if [ -n "$edate" ]
then
        edate_s=$(date "+%s" --date "$edate")
        now_s=$(date "+%s")
        CALC=$((($edate_s-$now_s)/24/3600))
        echo $CALC
else
        exit 1
fi
