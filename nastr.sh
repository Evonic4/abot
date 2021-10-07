#!/bin/bash

file1=/usr/share/alert_bot/settings.conf

v1=$1
v2=$2
v3=$3

perl -pi -e "if (\$.==12) {s/.*/$v1/ && end}" "$file1"
perl -pi -e "if (\$.==13) {s/.*/$v2/ && end}" "$file1"
perl -pi -e "if (\$.==14) {s/.*/$v3/ && end}" "$file1"
