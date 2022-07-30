#!/bin/bash
RED='\e[1;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
NC='\e[0m'
MYIP=$(wget -qO- ipinfo.io/ip);

clear
uuid=$(cat /etc/trojan/uuid.txt)
source /var/lib/premium-script/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/v2ray/domain)
else
domain=$IP
fi
tr="$(cat ~/log-install.txt | grep -i Trojan | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
		read -rp "Username: " -e user
		user_EXISTS=$(grep -w $user /etc/trojan/akun.conf | wc -l)

		if [[ ${user_EXISTS} == '1' ]]; then
			echo ""
			echo "Username already used"
			exit 1
		fi
	done
read -p "Expired (days): " masaaktif
sed -i '/"'""password""'"$/a\,"'""$user""'"' /etc/trojan/config.json
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
echo -e "### $user $exp" >> /etc/trojan/akun.conf
systemctl restart trojan
echo -e "\033[32m[Info]\033[0m Trojan-GFW Start Successfully !"
sleep 2
trojanlink="trojan://${user}@${domain}:${tr}"
trojanlink2="trojan://${user}@${MYIP}:${tr}"
clear
echo -e ""
cat /usr/bin/bannerku | lolcat
echo -e "=============-Trojan-============" | lolcat
echo -e "Remarks        : ${user}" | lolcat
echo -e "Host/IP        : ${domain}" | lolcat
echo -e "port           : ${tr}" | lolcat
echo -e "Key            : ${user}" | lolcat
echo -e "link1          : ${trojanlink}" | lolcat
echo -e "link2  		: ${trojanlink2}" | lolcat
echo -e "=================================" | lolcat
echo -e "Expired On     : $exp" | lolcat
echo -e "=================================" | lolcat
echo -e " °Script Mod By GABROK°  " | lolcat
echo -e "=================================" | lolcat
