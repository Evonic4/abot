#!/bin/bash

#переменные
fhome=/usr/share/alert_bot/
fcache1=/dev/cache/1/
fcache2=/dev/cache/2/
fPIDcu2=$fhome"cu2_pid.txt"
f_send=$fhome"abot2.txt"

ftb=$fhome
cuf=$fhome

[ "$1" -eq "1" ] && fcache1=/usr/share/alert_bot/cache/1/ && fcache2=/usr/share/alert_bot/cache/2/

chat_id1=$(sed -n 9"p" $fhome"settings.conf" | sed 's/z/-/g' | tr -d '\r')
chat_id2=$(sed -n 10"p" $fhome"settings.conf" | sed 's/z/-/g' | tr -d '\r')



function alert_bot() #проверка поступления алертов от менеджера
{

echo "alert_bot checks"

#chmod +rx -R $fcache1
find $fcache1 -maxdepth 1 -type f -name '*.txt' | sort > $fhome"a.txt"
str_col=$(grep -cv "^---" $fhome"a.txt")
echo "str_col="$str_col

for (( i=1;i<=$str_col;i++)); do
test=`basename $(sed -n $i"p" $fhome"a.txt" | tr -d '\r')`
head -n 7 $fcache1$test | tail -n 1 | jq '' > $fcache2$test
echo $fcache2$test" ok"
cat $fcache2$test

rm -f $fcache1$test
num_alerts=`grep -c description $fcache2$test`
redka;

rm -f $fcache2$test
done

echo "alert_bot checks ok"

}

function gen_id_alert() 
{

oldid=$(sed -n 1"p" $fhome"id.txt" | tr -d '\r')
newid=$((oldid+1))
echo $newid > $fhome"id.txt"

}

function redka() #выдергиваем проблемы из сообщений менеджера
{
echo "start redka"
echo $fcache2$test
echo "num_alerts="$num_alerts

rm -f $f_send

for (( i1=$((num_alerts-1));i1>=0;i1--)); do
desc=`cat $fcache2$test | jq '.alerts['${i1}'].annotations.description' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
status=`cat $fcache2$test | jq '.alerts['${i1}'].status' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
finger=`cat $fcache2$test | jq '.alerts['${i1}'].fingerprint' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`

echo $i1
echo "finger="$finger
echo "desc="$desc
echo "status="$status


num=$(grep -n "$finger" $fhome"alerts.txt" | awk -F":" '{print $1}')
echo "num="$num

#if ! [ "$(grep "$finger" $fhome"alerts.txt")" ]; then
if [ -z "$num" ]; then
	echo "-"
	if ! [ "$(grep $finger $fhome"delete.txt")" ]; then
	if [ "$status" == "firing" ]; then
		echo "-1"
		echo "$finger" >> $fhome"alerts.txt"
		gen_id_alert;
		echo $newid" "$desc >> $fhome"alerts2.txt"
		echo "[ALERT] "$newid" "$desc >> $f_send
		to_send;
	fi
	else
	echo "finger "$finger" already removed earlier"
	fi
else
	echo "+"
	if [ "$status" == "resolved" ]; then
		echo "+1"
		
		str_col2=$(grep -cv "^#" $fhome"alerts.txt")
		echo "str_col2="$str_col2
		
		
		desc1=$(sed -n $num"p" $fhome"alerts2.txt" | tr -d '\r')
		
		head -n $((num-1)) $fhome"alerts2.txt" > $fhome"alerts2_tmp.txt"
		tail -n $((str_col2-num)) $fhome"alerts2.txt" >> $fhome"alerts2_tmp.txt"
		cp -f $fhome"alerts2_tmp.txt" $fhome"alerts2.txt"
		
		grep -v "$finger" $fhome"alerts.txt" > $fhome"alerts_tmp.txt"
		cp -f $fhome"alerts_tmp.txt" $fhome"alerts.txt"
		
		echo "[OK] "$desc1 >> $f_send
		to_send;
	fi
fi

done

#to_send;

}


function to_send() #подготовка сообщений к отправке в телегу
{
echo  "start to_send"

if [ -f $f_send ]; then							
	regim=$(sed -n 1"p" $fhome"amode.txt" | tr -d '\r')
	if [ "$regim" -eq "1" ]; then
		echo "regim ON"												#есть данные для опопвещения в чат	
		echo "chat alert chat_id="$chat_id2", otv="$otv
		otv="/usr/share/alert_bot/abot2.txt"; send1=1; send;
		rm -f $f_send
	fi
fi

}


send1 ()  		#функция1 отправки ответа в чат
{
echo "send1 start"

again0="yes"
while [ "$again2" = "yes" ]
do
sleep 1
if ! [ -f $ftb"cu21_pid.txt" ]; then
	again0="no"
fi
done


echo $chat_id > $cuf"send21.txt"
echo $otv >> $cuf"send21.txt"

rm -f $cuf"out21.txt"
file=$cuf"out21.txt"; 
$ftb"cucu21.sh" &
sleep 2

if [ -f $cuf"out.txt" ]; then
	if [ "$(cat $cuf"out.txt" | grep ":true,")" ]; then		#ответ отправлен
		echo "send OK"
	else
		echo "send file+, timeout.."
		cat $cuf"out.txt" >> $log
		sleep 2
	fi
else														#ответ не отправлен
	echo "send FAIL"
	if [ -f $cuf"cu2_pid.txt" ]; then
		echo "send kill cucu21"
		cu_pid=$(sed -n 1"p" $cuf"cu2_pid.txt" | tr -d '\r')
		killall cucu21.sh
		kill -9 $cu_pid
		rm -f $cuf"cu21_pid.txt"
	fi
fi

echo "send1 exit"

}

send ()  		#функция отправки ответа в чат
{
echo "send start"
rm -f $cuf"send21.txt"

if [ "$send1" -eq "2" ]; then
		chat_id=$chat_id2
	else
		chat_id=$chat_id1
fi
echo "chat_id="$chat_id

dl=$(wc -m $otv | awk '{ print $1 }')
echo "dl="$dl
if [ "$dl" -gt "4000" ]; then
	sv=$(echo "$dl/4000" | bc)
	echo "sv="$sv
	$ftb"rex.sh" $otv
	
	for (( i=1;i<=$sv;i++)); do
		otv="/usr/share/alert_bot/reza"$i".txt"
		send1;
		rm -f "/usr/share/alert_bot/reza"$i".txt"
	done
	
else
	send1;
fi

echo "send exit"
}



echo "start"
while true
do
sleep 2
alert_bot;
to_send;
done






