#!/bin/bash

#check updates for system
apt-get update -y
apt-get update -y

#install usefull packages
apt-get install sudo vim portsentry fail2ban apache2 mailutils git -y

#config static ip
rm -rf /etc/network/interfaces
cp /root/deploy/src/interfaces /etc/network/interfaces
ifup enp0s8

#config ssh
rm -rf /etc/ssh/sshd_config
cp /root/deploy/src/sshd_config /etc/ssh/sshd_config

#config apache and web deployment
cp /root/deploy/src/ssl-params.conf /etc/apache2/
rm -rf /etc/apache2/sites-available/default-ssl.conf
cp /root/deploy/src/default-ssl.conf /etc/apache2/sites-available/
rm -rf /etc/apache2/sites-available/000-default.conf
cp /root/deploy/src/000-defaults.conf /etc/apache2/sites-available/
a2enmod ssl
a2enmod headers
a2ensite default-ssl
a2enconf ssl-params
rm -rf /var/www/html/index.html
cp /root/deploy/site/* /var/www/html/

#config firewall
ufw enable
ufw allow 34048/tcp
ufw allow 80/tcp
ufw allow 443/tcp

#config fail2ban
rm -rf /etc/fail2ban/jail.conf
cp /root/deploy/src/jail.conf /etc/fail2ban/

#config portsentry
rm -rf /etc/default/portsentry
cp /root/deploy/src/portsentry /etc/default/
rm -rf /etc/portsentry/portsentry.conf
cp /root/deploy/src/porsentry.conf /etc/portsentry/

reboot
