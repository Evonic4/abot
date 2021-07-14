#!/bin/bash
#тестовый скрипт переносит значения в алерты

#переменные
fhome=/usr/share/alert_bot/
fcache1=/dev/cache/1/
fcache2=/dev/cache/2/


function redka()
{
echo "redka"
echo $fcache2$test
echo "num_alerts="$num_alerts


for (( i1=$((num_alerts-1));i1>=0;i1--)); do
desc=`cat $fcache2$test | jq '.alerts['${i1}'].annotations.description' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
#alertname=`cat $fcache2$test | jq '.alerts['${i1}'].labels.alertname' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
#instance=`cat $fcache2$test | jq '.alerts['${i1}'].labels.instance' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
status=`cat $fcache2$test | jq '.alerts['${i1}'].status' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
finger=`cat $fcache2$test | jq '.alerts['${i1}'].fingerprint' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`

echo $i1
echo "finger="$finger
echo "desc="$desc
#echo "alertname="$alertname
#echo "instance="$instance
echo "status="$status


num=$(grep -n "$finger" $fhome"alerts.txt" | awk -F":" '{print $1}')
echo "num="$num

#if ! [ "$(grep "$finger" $fhome"alerts.txt")" ]; then
if [ -z "$num" ]; then
	echo "-"
	if [ "$status" == "firing" ]; then
		echo "-1"
		echo "$finger" >> $fhome"alerts.txt"
		echo "$desc" >> $fhome"alerts2.txt"
		echo "[ALERT] "$desc
	fi
else
	echo "+"
	if [ "$status" == "resolved" ]; then
		echo "+1"
		
		str_col2=$(grep -cv "^#" $fhome"alerts.txt")
		echo "str_col2="$str_col2
		
		head -n $((num-1)) $fhome"alerts2.txt" > $fhome"alerts2_tmp.txt"
		tail -n $((str_col2-num)) $fhome"alerts2.txt" >> $fhome"alerts2_tmp.txt"
		cp -f $fhome"alerts2_tmp.txt" $fhome"alerts2.txt"
		
		grep -v "$finger" $fhome"alerts.txt" > $fhome"alerts_tmp.txt"
		cp -f $fhome"alerts_tmp.txt" $fhome"alerts.txt"
		
		echo "[OK] "$desc
	fi
fi

done
}








chmod +rx -R $fcache1
find $fcache1 -maxdepth 1 -type f -name '*.txt' | sort > $fhome"a.txt"
str_col=$(grep -cv "^#" $fhome"a.txt")
echo "str_col="$str_col

for (( i=1;i<=$str_col;i++)); do
test=`basename $(sed -n $i"p" $fhome"a.txt" | tr -d '\r')`
head -n 7 $fcache1$test | tail -n 1 | jq '' > $fcache2$test
echo $fcache2$test" ok"
cat $fcache2$test

rm -f $fcache1$test
num_alerts=`grep -c description $fcache2$test`
redka

rm -f $fcache2$test
done



#jq '.alerts[1].fingerprint'
#jq '.alerts[1].annotations.description'
#jq '.alerts[1].labels.alertname'
#jq '.alerts[1].labels.instance'
#jq '.alerts[1].status'

#fingerprint
#"description": "Site http://192.168.8.6 isn't available(down)"
#"alertname": "http_status_code_not_200-299"  "alertname": "site_down"  "alertname": "site_is_very_slow"  
#"instance": "http://192.168.8.6"
#"status": "firing"   "status": "resolved",
 




