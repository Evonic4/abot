# alert_bot

install from root  
cd /usr/share/ && git clone https://github.com/Evonic4/alert_bot.git && chmod +rx /usr/share/alert_bot/setup.sh && /usr/share/alert_bot/setup.sh  
  
change  
/usr/share/settings.conf  
  
start  
su mastmetric -c '/usr/share/alert_bot/trbot.sh 2' -s /bin/bash  
  
log  
/var/log/trbot/trbot.log  
  
alertmanager conf  
/usr/share/alert_bot/alertmanager/config.yml  
  
docker  
cd /usr/share/alert_bot/docker/ && docker-compose up  
  