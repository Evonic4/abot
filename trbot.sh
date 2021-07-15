#!/bin/bash
#основной скрипт телеграм-бота

#переменные
fhome=/usr/share/alert_bot/
#fcache1=/dev/cache/1/
#fcache2=/dev/cache/2/
fcache1=/usr/share/alert_bot/cache/1/
fcache2=/usr/share/alert_bot/cache/2/

[ "$1" -eq "1" ] && /usr/share/alert_bot/abot1.sh 1 &
#echo "1:"$1 
#[ "$1" -eq "1" ] && echo "start abot1" && fcache1=/usr/share/alert_bot/cache/1/ && fcache2=/usr/share/alert_bot/cache/2/ && /usr/share/alert_bot/abot1.sh 1 &
#mkdir -p /dev/cache && chmod 777 /dev/cache && mount -t tmpfs -o size=100M tmpfs /dev/cache && mkdir -p /dev/cache/1 && mkdir -p /dev/cache/2 &&

ftb=$fhome
cuf=$fhome
fm=$fhome"mail.txt"
mass_mesid_file=$fhome"mmid.txt"
home_trbot=$fhome



function Init2() #инициализация переменных из конфига settings.conf
{
logger "text="
log=$(sed -n 2"p" $ftb"settings.conf" | tr -d '\r')
regim=$(sed -n 3"p" $ftb"settings.conf" | tr -d '\r')
fPID=$(sed -n 4"p" $ftb"settings.conf" | tr -d '\r')
f_send=$(sed -n 5"p" $ftb"settings.conf" | tr -d '\r')
sec=$(sed -n 6"p" $ftb"settings.conf" | tr -d '\r')
opov=$(sed -n 7"p" $ftb"settings.conf" | tr -d '\r')
chat_id1=$(sed -n 9"p" $ftb"settings.conf" | tr -d '\r')
chat_id2=$(sed -n 10"p" $ftb"settings.conf" | tr -d '\r')
progons=$(sed -n 11"p" $ftb"settings.conf" | tr -d '\r')
}

Init2;
send1=0

function logger()		#функция логирования
{
local date1=`date '+ %Y-%m-%d %H:%M:%S'`
echo $date1" trbot: "$1 >> $log
}


if ! [ -f $log ]; then	#инициализация файла логирования
echo " " > $log
else
echo " " >> $log
fi




regstat()	#функция смены настроек Alerting mode в конфигурационном файле
{
str_col=$(grep -cv "^T" $ftb"settings.conf")
echo "str_col="$str_col

rm -f $ftb"settings1.conf" && touch $ftb"settings1.conf"

for (( i=1;i<=$str_col;i++)); do
test=$(sed -n $i"p" $ftb"settings.conf")
if [ "$i" -eq "3" ]; then
echo $regim >> $ftb"settings1.conf"
else
echo $test >> $ftb"settings1.conf"
fi
done

[ "$regim" -eq "1" ] && echo "Alerting mode ON" > $ftb"regim.txt"
[ "$regim" -eq "0" ] && echo "Alerting mode OFF" > $ftb"regim.txt"
otv="/usr/share/alert_bot/regim.txt"
send1=1; send;

cp -f $ftb"settings1.conf" $ftb"settings.conf"
}


roborob ()  		#функция выполнения команд боту
{
date1=`date '+ %d.%m.%Y %H:%M:%S'`
logger "text="$text
otv=""

if [ "$text" = "/start" ] || [ "$text" = "/?" ] || [ "$text" = "/help" ] || [ "$text" = "/h" ]; then
	otv="/usr/share/alert_bot/start.txt"
	send1=1; send;
fi

if [ "$text" = "/j" ] || [ "$text" = "/job" ]; then
	$ftb"job.sh"
	otv="/usr/share/alert_bot/job.txt"
	send1=1; send;
fi

if [ "$text" = "/ss" ] || [ "$text" = "/status" ]; then
	$ftb"ss.sh"
	otv="/usr/share/alert_bot/ss.txt"
	send1=1; send;
fi

if [[ "$text" == */d* ]]; then
	$ftb"del.sh" $text
	otv="/usr/share/alert_bot/del.txt"
	send1=1; send;
fi

if [ "$text" = "/on" ]; then
	regim=1;
	regstat;
fi

if [ "$text" = "/off" ]; then
	regim=0;
	regstat;
fi

logger "roborob otv="$otv
}


send ()  		#функция отправки ответа в чат
{
logger "send start"
rm -f $cuf"send.txt"

if [ "$send1" -eq "2" ]; then
		chat_id2=$(sed -n 10"p" $ftb"settings.conf" | sed 's/z/-/g' | tr -d '\r')
		chat_id=$chat_id2

	else
		chat_id1=$(sed -n 9"p" $ftb"settings.conf" | sed 's/z/-/g' | tr -d '\r')
		chat_id=$chat_id1

fi


#chat_id1=$(sed -n "1p" $frecid | sed 's/z/-/g' | tr -d '\r')
logger "chat_id="$chat_id
		echo $chat_id > $cuf"send.txt"
		echo $otv >> $cuf"send.txt"

rm -f $cuf"out.txt"
file=$cuf"out.txt"; 
$ftb"cucu2.sh" &
pauseloop;

if [ -f $cuf"out.txt" ]; then
	if [ "$(cat $cuf"out.txt" | grep ":true,")" ]; then		#ответ отправлен
		logger "send OK"
	else
		logger "send file+, timeout.."
		cat $cuf"out.txt" >> $log
		sleep 2
	fi
else														#ответ не отправлен
	logger "send FAIL"
	if [ -f $cuf"cu2_pid.txt" ]; then
		logger "send kill cucu2"
		cu_pid=$(sed -n 1"p" $cuf"cu2_pid.txt" | tr -d '\r')
		killall cucu2.sh
		kill -9 $cu_pid
		rm -f $cuf"cu2_pid.txt"
	fi
fi

logger "send exit"
}

pauseloop ()  		#функция сна на $sec сек
{
sec1=0
rm -f $file
again0="yes"
while [ "$again0" = "yes" ]
do
sec1=$((sec1+1))
sleep 1
if [ -f $file ] || [ "$sec1" -eq "$sec" ]; then
	again0="go"
	logger "pauseloop sec1="$sec1
fi
done
}

input ()  		#функция получения данных с сервера telegram
{
logger "input start"

rm -f $cuf"in.txt"
file=$cuf"in.txt";
$ftb"cucu1.sh" &
pauseloop;

if [ -f $cuf"in.txt" ]; then
	if [ "$(cat $cuf"in.txt" | grep ":true,")" ]; then		#ответ получен
		logger "input OK"
	else
		logger "input file+, timeout.." #error_code
		cat $cuf"in.txt" >> $log
		ffufuf1=1
		sleep 2
	fi
else														#ответ не получен
	logger "input FAIL"
	if [ -f $cuf"cu1_pid.txt" ]; then
		logger "input kill cucu1"
		cu_pid=$(sed -n 1"p" $cuf"cu1_pid.txt" | tr -d '\r')
		killall cucu1.sh
		kill -9 $cu_pid
		rm -f $cuf"cu1_pid.txt"
		ffufuf1=1
	fi
fi

logger "input exit"
}


lastidrass ()  				#хранитель последнего id ответа от сервера telegram
{
if [ "$last_id" -lt "$mi" ]; then
	last_id=$mi
	echo $last_id > $ftb"lastid.txt"
	logger "new last_id="$last_id
fi

}


parce ()					#функция парсинга ответов от сервера telegram
{
logger "parce"
date1=`date '+ %d.%m.%Y %H:%M:%S'`
mi_col=$(cat $cuf"in.txt" | grep -c update_id | tr -d '\r')
logger "parce col mi_col ="$mi_col

if [ "$mi_col" -eq "0" ] && [ "$ffufuf1" -eq "0" ]; then
	echo "" > $mass_mesid_file
fi


for (( i=1;i<=$mi_col;i++)); do
	i1=$((i-1))
	mi=$(cat $cuf"in.txt" | jq ".result[$i1].update_id" | tr -d '\r')
	#logger "update_id="$mi
	
	ffufuf=0
	for x in `cat $mass_mesid_file|grep -v \#|tr -d '\r'`
	do
		if [ "$x" -eq "$mi" ]; then
			ffufuf=1
			#logger "processed"
		fi
	done
	
	
	if [ "$ffufuf" -eq "0" ]; then
		chat_id=$(cat $cuf"in.txt" | jq ".result[$i1].message.chat.id" | sed 's/-/z/g' | tr -d '\r')
		logger "chat_id="$chat_id
		if [ "$(echo $chat_id1 | grep $chat_id)" ]; then
			logger "parse chat_id="$chat_id" -> OK"
			#chat_id=$chat_id
			text=$(cat $cuf"in.txt" | jq ".result[$i1].message.text" | sed 's/\"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
			logger $text
			echo $text > $home_trbot"t.txt"
			roborob;
			
			#lastidrass;
			logger "parce ok"
			echo $mi >> $mass_mesid_file
		else
			#lastidrass;
			logger "parce dont! chat_id="$chat_id" NOT OK"
		fi
	fi
	
done
}


function gen_id_alert() #генератор UUID для проблем
{

oldid=$(sed -n 1"p" $fhome"id.txt" | tr -d '\r')
newid=$((oldid+1))
echo $newid > $fhome"id.txt"

}

function redka() #выдергиваем проблемы из сообщений менеджера
{
logger "start redka"
logger $fcache2$test
logger "num_alerts="$num_alerts

rm -f $f_send

for (( i1=$((num_alerts-1));i1>=0;i1--)); do
desc=`cat $fcache2$test | jq '.alerts['${i1}'].annotations.description' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
#alertname=`cat $fcache2$test | jq '.alerts['${i1}'].labels.alertname' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
#instance=`cat $fcache2$test | jq '.alerts['${i1}'].labels.instance' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
status=`cat $fcache2$test | jq '.alerts['${i1}'].status' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
finger=`cat $fcache2$test | jq '.alerts['${i1}'].fingerprint' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`

logger $i1
logger "finger="$finger
logger "desc="$desc
#echo "alertname="$alertname
#echo "instance="$instance
logger "status="$status


num=$(grep -n "$finger" $fhome"alerts.txt" | awk -F":" '{print $1}')
logger "num="$num

#if ! [ "$(grep "$finger" $fhome"alerts.txt")" ]; then
if [ -z "$num" ]; then
	logger "-"
	if ! [ "$(grep $finger $fhome"delete.txt")" ]; then
	if [ "$status" == "firing" ]; then
		logger "-1"
		echo "$finger" >> $fhome"alerts.txt"
		gen_id_alert;
		echo $newid" "$desc >> $fhome"alerts2.txt"
		echo "[ALERT] "$newid" "$desc >> $f_send
	fi
	else
	logger "finger "$finger" already removed earlier"
	fi
else
	logger "+"
	if [ "$status" == "resolved" ]; then
		logger "+1"
		
		str_col2=$(grep -cv "^#" $fhome"alerts.txt")
		logger "str_col2="$str_col2
		
		
		desc1=$(sed -n $num"p" $fhome"alerts2.txt" | tr -d '\r')
		
		head -n $((num-1)) $fhome"alerts2.txt" > $fhome"alerts2_tmp.txt"
		tail -n $((str_col2-num)) $fhome"alerts2.txt" >> $fhome"alerts2_tmp.txt"
		cp -f $fhome"alerts2_tmp.txt" $fhome"alerts2.txt"
		
		grep -v "$finger" $fhome"alerts.txt" > $fhome"alerts_tmp.txt"
		cp -f $fhome"alerts_tmp.txt" $fhome"alerts.txt"
		
		echo "[OK] "$desc1 >> $f_send
	fi
fi

done

to_send;

}



function alert_bot() #проверка поступления алертов от менеджера
{

logger "alert_bot checks"

#chmod +rx -R $fcache1
find $fcache1 -maxdepth 1 -type f -name '*.txt' | sort > $fhome"a.txt"
str_col=$(grep -cv "^#" $fhome"a.txt")
logger "str_col="$str_col

for (( i=1;i<=$str_col;i++)); do
test=`basename $(sed -n $i"p" $fhome"a.txt" | tr -d '\r')`
head -n 7 $fcache1$test | tail -n 1 | jq '' > $fcache2$test
logger $fcache2$test" ok"
cat $fcache2$test

rm -f $fcache1$test
num_alerts=`grep -c description $fcache2$test`
redka;

rm -f $fcache2$test
done

logger "alert_bot checks ok"

}


function to_send() #подготовка сообщений к отправке в телегу
{
logger "start to_send"

if ! [ -f $f_send ]; then							#нет данных для опопвещения в чат
	chat_id1=$(sed -n 9"p" $ftb"settings.conf" | tr -d '\r')
else 
	if [ "$regim" -eq "1" ]; then
		logger "regim ON"												#есть данные для опопвещения в чат	
		chat_id2=$(sed -n 10"p" $ftb"settings.conf" | sed 's/z/-/g' | tr -d '\r')
		otv=$f_send
		logger "chat alert chat_id="$chat_id2", otv="$otv
		send1=2; send;
		rm -f $f_send
	fi
fi

}




if ! [ -f $fPID ]; then	#старт скрипта
PID=$$
echo $PID > $fPID

logger "start"
logger "chat_id1="$chat_id1
logger "chat_id2="$chat_id2

kkik=0

while true
do
sec4=$(sed -n "8p" $ftb"settings.conf" | tr -d '\r')
sleep $sec4
ffufuf1=0

#---------------------
alert_bot;
#---------------------
to_send;

input;
parce;

kkik=$(($kkik+1))
[ "$kkik" -eq "$progons" ] && Init2

done


else #скрипт уже запущен
	logger "pid up exit"

fi #конец фильма2


rm -f $fPID




