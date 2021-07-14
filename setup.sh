#!/bin/bash

f1=/usr/share/alert_bot/

(crontab -l ; echo "@reboot mkdir -p /dev/cache && chmod 777 /dev/cache && mount -t tmpfs -o size=100M tmpfs /dev/cache && mkdir -p /dev/cache/1 && mkdir -p /dev/cache/2 && su mastmetric -c '/usr/share/alert_bot/abot1.sh' -s /bin/bash &")| crontab -

useradd -d /dev/null -G adm -p 12345 -s /bin/bash mastmetric
chown -R mastmetric:mastmetric /usr/share/alert_bot/
cp -r -f ./logrotate /etc/logrotate.d/ 

cd /etc/logrotate.d/
chown root:root *
chmod 640 *

mkdir -p /var/log/trbot
chown -R mastmetric:mastmetric /var/log/trbot


cd $f1
ls | sed -n '/.sh/p' | sed 's/setup.sh//g' | sed '/^$/d' > $f1"fs"

for x in `cat $f1"fs"|grep -v \#`
do
chmod +rx $x
perl -pi -e "s/\r\n/\n/" $x
echo $x
done


ls | sed -n '/.php/p' | sed '/^$/d' > $f1"fs"

for x in `cat $f1"fs"|grep -v \#`
do
chmod +rx $x
perl -pi -e "s/\r\n/\n/" $x
echo $x
done

ls | sed -n '/.py/p' | sed '/^$/d' > $f1"fs"

for x in `cat $f1"fs"|grep -v \#`
do
chmod +rx $x
perl -pi -e "s/\r\n/\n/" $x
echo $x
done

chown -R mastmetric:mastmetric /usr/share/alert_bot/
logrotate -vdf *
mkdir -p /dev/cache && chmod 777 /dev/cache && mount -t tmpfs -o size=100M tmpfs /dev/cache && mkdir -p /dev/cache/1 && mkdir -p /dev/cache/2 && su mastmetric -c '/usr/share/alert_bot/abot1.sh' -s /bin/bash &

[ "$1" -eq "1" ] && su mastmetric -c '/usr/share/alert_bot/trbot.sh' -s /bin/bash 
