#!/bin/bash
red="\e[1;31m"
gren="\e[1;32m"
blue="\e[1;34m"
yelow="\e[1;33m"
cyan="\e[1;36m"
white="\e[1;37m"
NC="\e[0m"
fi
clear
rm /etc/v2ray/domain
rm /var/lib/premium-script/ipvps.conf
echo "Checking Vps"
curl -o.html https://icanhazip.com
sleep 0.5
clear                                                     
read -p "Hostname / Domain: " host
echo "IP=$host" >> /var/lib/premium-script/ipvps.conf
echo "$host" >> /etc/v2ray/domain
sleep 1
clear
echo -e DOMAIN BERHASIL DITAMBAHKAN                                                                                            
echo "Harap Update certificate v2ray dengan"
echo "Mengetikkan Perintah certv2ray"
