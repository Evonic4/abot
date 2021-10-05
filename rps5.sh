#!/bin/bash

fhome=/root/scripts/

promapi=$(sed -n 13"p" $fhome"settings.conf" | tr -d '\r')

curl -s --location --request POST $promapi \
--header 'Accept: application/json' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'query=sum(rate(http_requests_received_total{action=~"",job!="mixvel-ets.*"}[5m])/300) by(job)' | jq '' > $fhome"rps1.txt"



cat $fhome"rps1.txt" | jq '.data.result[].metric.job' | sed 's/\"/ /g' | sed 's/-api-metrics/ /g' | sed 's/mixvel-/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//' > $fhome"rps2.txt"
cat $fhome"rps1.txt" | jq '.data.result[].value[1]' | sed 's/\"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//' | awk '{printf("%.4f \n",$1)}' > $fhome"rps3.txt"
paste $fhome"rps2.txt" $fhome"rps3.txt" > $fhome"rps4.txt"
grep -v "ets-tch" $fhome"rps4.txt" > $fhome"rps.txt"
echo "----" >> $fhome"rps.txt"
