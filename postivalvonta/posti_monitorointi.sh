#!/bin/bash
# Tool for polling data from finnish postal service about foreign shipments and forwarding them to telegram bot
# Esamatti Käkelä <ekakela@gmail.com>
# Replace "PATH" with the location of files
# Creating necessary temp files.
FILE=$(mktemp)
JS=$(mktemp)
#Initialize status tracking for this 
if [ ! -f /tmp/$1 ];
then 
echo 0 > /tmp/$1
fi

trap "rm $FILE $JS" 0 1 2 3 15

A=$(cat /tmp/$1)
NICK=$2

sed s/ABC/$1/g PATH/template_posti.js >> $JS
./phantomjs $JS >> $FILE
DHL=$(grep -A1 "Toinen" $FILE| tail -1)
SUOMI=$(grep "kohdemaahan" $FILE)
ST=$(grep -A1 "kohdemaahan" $FILE|tail -1)
KULJ=$(grep "Lähetystä kuljetetaan vastaanottajalle." $FILE)
KT=$(grep -A1 "Lähetystä kuljetetaan vastaanottajalle." $FILE|tail -1)
LUO=$(grep "luovutettu vastaanottajalle." $FILE)
LT=$(grep -A1 "luovutettu vastaanottajalle." $FILE|tail -1)



case "$A" in
0)
if [ -z "$SUOMI" ];
	then  
		exit
	else  
		echo 1 > /tmp/$1
		MESSAGE="@$NICK Lähetyksen $DHL tila on muuttunut: $ST $SUOMI"
	        ~/PATH-TO-TELEGRAM-BOT "$MESSAGE"
fi
;;

1)
if [ -z "$KULJ" ];
	then
		exit 0
	else
		echo 2 > /tmp/$1
		MESSAGE="@$NICK Lähetyksen $DHL tila on muuttunut: $KT $KULJ"
		~/PATH-TO-TELEGRAM-BOT "$MESSAGE"
fi
;;
2)
if [ -z "$LUO" ];
	then
		exit 0
	else
	echo 3 > /tmp/$1
	MESSAGE="@$NICK Lähetyksen $DHL tila on muuttunut: $LT $LUO"
	~/PATH-TO-TELEGRAM-BOT "$MESSAGE"
fi
;;
3) 
#After reporting that the package has been delivered remove the package from monitoring. 
rm PATH/valvottavat-paketit/$1
exit 0
esac

