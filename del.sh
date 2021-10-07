#!/bin/bash

home_trbot=/usr/share/alert_bot/
fhome=$home_trbot
iter=$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8
echo $iter | tr " " "\n" > $home_trbot"temp_del.txt"

state="ok"

function deleteler() 
{
[ "$test" == "all" ] && cat $fhome"alerts.txt" >> $fhome"delete.txt" && rm -f $home_trbot"alerts2.txt" && rm -f $home_trbot"alerts.txt" && touch $home_trbot"alerts2.txt" && touch $home_trbot"alerts.txt" && echo $test" check" && echo "delete all ok" > $home_trbot"del.txt" && exit 0

str_col2=$(grep -cv "^#" $home_trbot"alerts2.txt")
echo "str_col2="$str_col2

num=$(grep -n "$test" $fhome"alerts2.txt" | awk -F":" '{print $1}')
echo "num="$num

if [ -z "$num" ]; then	
	state="NOT ok"
	echo $test" not find"
else					
		state="ok"
		
		fp=$(sed -n $num"p" $fhome"alerts.txt" | tr -d '\r')
		echo $fp >> $fhome"delete.txt"										
		
		head -n $((num-1)) $fhome"alerts2.txt" > $fhome"alerts2_tmp.txt"
		tail -n $((str_col2-num)) $fhome"alerts2.txt" >> $fhome"alerts2_tmp.txt"
		cp -f $fhome"alerts2_tmp.txt" $fhome"alerts2.txt"
		
		head -n $((num-1)) $fhome"alerts.txt" > $fhome"alerts1_tmp.txt"
		tail -n $((str_col2-num)) $fhome"alerts.txt" >> $fhome"alerts1_tmp.txt"
		cp -f $fhome"alerts1_tmp.txt" $fhome"alerts.txt"
		
		echo $test" check"
fi

}

str_col=$(grep -cv "^#" $home_trbot"temp_del.txt")
echo "str_col="$str_col

for (( i=1;i<=$str_col;i++)); do
	rm -f $home_trbot"in_id2.txt"
	test=$(sed -n $i"p" $home_trbot"temp_del.txt" | tr -d '\r')
	echo "del_id="$test
	deleteler;
done

echo "delete "$state", jobs now:" > $home_trbot"del.txt"	
cat $home_trbot"alerts2.txt" >> $home_trbot"del.txt"
echo "----" >> $home_trbot"del.txt"

cat $home_trbot"del.txt"


