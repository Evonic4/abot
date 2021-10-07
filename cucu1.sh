#!/bin/bash
#получение команд телеграм-бота из чата

#переменные
ftb=/usr/share/alert_bot/
cuf=/usr/share/alert_bot/
fPID=/usr/share/alert_bot/cu1_pid.txt


if ! [ -f $fPID ]; then
PID=$$
echo $PID > $fPID
token=$(sed -n 1"p" $ftb"settings.conf" | tr -d '\r')
last_id=$(sed -n 1"p" $ftb"lastid.txt" | tr -d '\r')

curl -L https://api.telegram.org/bot$token/getUpdates?offset=$last_id > $cuf"in0.txt"
mv $cuf"in0.txt" $cuf"in.txt"

fi
rm -f $fPID
