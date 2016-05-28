#!/bin/bash
# Esamatti Käkelä <ekakela@gmail.com> 
# Tool for monitoring finnish postal service packages 
# Replace "PATH" with the location of files
# This is run periodically by cron
FILES=PATH/valvottavat-paketit/*
A=$(ls -1 PATHs/valvottavat-paketit/|wc -l)
if [ $A -eq 0 ];
then 
exit 0;
else 
for f in $FILES
do
  PAKETTI=$(head -1 $f)
  VAST=$(tail -1 $f)
  PATH/posti_monitorointi.sh $PAKETTI $VAST
done
fi
