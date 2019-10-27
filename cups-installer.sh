#!/bin/bash
#Author: Michi Freund
#Email: m.freund@anykey.ch
#Date: 29.08.2019
#Purpose: CUPS Configuration on the Fly
#Version: V1.0

ipaddr=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')

echo "Install CUPS Server. PLS waite!"
apt-get update >/dev/null
apt-get upgrade -y > /dev/null
apt-get install cups -y >/dev/null
printf "Installation of CUPS DONE!\n"


echo "Setup CUPS Server PLS waite!"
cp /etc/cups/cupsd.conf /etc/cups/cupsd.conf.BACKUP
sed -i '/Listen localhost:631/c\Port 631' /etc/cups/cupsd.conf >/dev/null
sed -i '/Browsing On/c\Browsing Off' /etc/cups/cupsd.conf >/dev/null
sed -i '/BrowseLocalProtocols dnssd/c\#BrowseLocalProtocols dnssd' /etc/cups/cupsd.conf >/dev/null
sed -i '/Order allow,deny/a  Allow @LOCAL' /etc/cups/cupsd.conf

sudo usermod -aG lpadmin root
sudo usermod -aG lpadmin admin
service cups restart
echo "Setup of CUPS DONE!"
printf "You can now access the CUPS Server over https://"$ipaddr":631/admin\nPLS visit following Homepage to get the correct PPD File\nhttp://www.openprinting.org/printers\n"
exit 0 
