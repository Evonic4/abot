#!/bin/bash

fhome=/usr/share/alert_bot/

promapi=$(sed -n 13"p" $fhome"settings.conf" | tr -d '\r')

curl -s --location --request POST $promapi \
--header 'Accept: application/json' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'query=rate(elcep_logs_matched_rpc_durations_app_errors_all_histogram_seconds_sum[30m])/1800' | jq '' > $fhome"err1.txt"


cat $fhome"err1.txt" | jq '.data.result[].value[1]' | sed 's/\"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//' | awk '{printf("%.6f \n",$1)}' > $fhome"err.txt"
echo "----" >> $fhome"err.txt"
