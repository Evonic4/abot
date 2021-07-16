FROM ubuntu:18.04
MAINTAINER Evonic4
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow

USER root
RUN apt update
RUN apt install -y wget git tar curl netcat jq && \
rm -rf /var/lib/apt/lists/* && \
apt clean

WORKDIR /usr/share/
RUN cd /usr/share/; \
git clone https://github.com/Evonic4/alert_bot.git; \
ls /usr/share/alert_bot;

WORKDIR /usr/share/alert_bot
RUN mkdir -p /var/log/trbot; 
RUN cp -r -f ./logrotate/trbot /etc/logrotate.d/; \
cd /etc/logrotate.d/; \
chown root:root *; \
chmod 640 *; \
ls /etc/logrotate.d;
#logrotate -f /etc/logrotate.conf

RUN mkdir -p /usr/share/alert_bot/cache/1; \
mkdir -p /usr/share/alert_bot/cache/2; \
chmod 777 /usr/share/alert_bot/cache;

RUN cd /usr/share/alert_bot/; \
chmod +x *.sh; \
useradd -d /dev/null -G adm -p 12345 -s /bin/bash mastmetric; \
chown -R mastmetric:mastmetric /usr/share/alert_bot/; \
chown -R mastmetric:mastmetric /var/log/trbot;

USER mastmetric
VOLUME ["/usr/share/alert_bot"]
WORKDIR /usr/share/alert_bot
ENTRYPOINT ["bash", "trbot.sh", "1"]
#CMD ["./trbot.sh 1"]

EXPOSE 9087
