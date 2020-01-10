#!/bin/bash

#check updates for system
apt-get update -y
apt-get update -y

#install usefull packages
apt-get install sudo vim portsentry fail2ban apache2 mailutils git -y

#config static ip
rm -rf /etc/network/interfaces
cp /src/interfaces /etc/network/interfaces
ifup enp0s8

#config ssh
rm -rf /etc/ssh/sshd_config
cp /src/sshd_config /etc/ssh/sshd_config

#config apache and web deployment
cp /src/ssl-params.conf /etc/apache2/
rm -rf /etc/apache2/sites-available/default-ssl.conf
cp /src/default-ssl.conf /etc/apache2/sites-available/
rm -rf /etc/apache2/sites-available/000-default.conf
cp /src/000-defaults.conf /etc/apache2/sites-available/
a2enmod ssl
a2enmod headers
a2ensite default-ssl
a2enconf ssl-params
rm -rf /var/www/html/index.html
cp /site/* /var/www/html/

#config firewall
ufw enable
ufw allow 34048/tcp
ufw allow 80/tcp
ufw allow 443/tcp

#config fail2ban
rm -rf /etc/fail2ban/jail.conf
cp /src/jail.conf /etc/fail2ban/

#config portsentry
rm -rf /etc/default/portsentry
cp /src/portsentry /etc/default/
rm -rf /etc/portsentry/portsentry.conf
cp /src/porsentry.conf /etc/portsentry/

reboot
