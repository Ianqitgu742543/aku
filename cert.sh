#!/bin/bash
# ==========================================
# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"
IZIN=$( curl http://po.awokawok.live/akses | grep $MYIP )
if [ $MYIP = $IZIN ]; then
echo -e "${green}Akses Di Izinkan...${NC}"
else
echo -e "${red}VPS tidak diijinkan${NC}";
echo "Kontak Admin Untuk Mendapatkan Akses Script" | lolcat
echo "WhatsApp : wa.me/6285717886076" | lolcat
exit 0
fi
clear

echo start
sleep 0.5
source /var/lib/premium-script/ipvps.conf
domain=$(cat /etc/v2ray/domain)
sudo lsof -t -i tcp:80 -s tcp:listen | sudo xargs kill
cd /root/
wget -O acme.sh https://raw.githubusercontent.com/acmesh-official/acme.sh/master/acme.sh
bash acme.sh --install
rm acme.sh
cd .acme.sh
echo "starting...., Port 80 Akan di Hentikan Saat Proses install Cert"
bash acme.sh --register-account -m jhonsarjuna@gmail.com
bash acme.sh --issue --standalone -d $domain --force
bash acme.sh --installcert -d $domain --fullchainpath /etc/v2ray/v2ray.crt --keypath /etc/v2ray/v2ray.key
