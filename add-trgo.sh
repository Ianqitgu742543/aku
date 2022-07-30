#!/bin/bash
domain=$(cat /etc/v2ray/domain)
read -rp "Username: " -e user
egrep -w "^### $user" /usr/local/etc/xray/trojanws.json >/dev/null
if [ $? -eq 0 ]; then
echo -e "Username Sudah Ada"

exit 0
fi
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#tls$/a\### '"$user $exp"'\},{"password": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/xray/trojanws.json
systemctl restart xray@trojanws
trojangolink="trojan-go://${uuid}@${domain}:443/?sni=${domain}&type=ws&host=${domain}&path=/GABROK&encryption=none#${user}"
clear

echo -e ""
cat /usr/bin/bannerku | lolcat
echo -e "===========-Trojan-GO-===========" | lolcat
echo -e "Remarks        : ${user}" | lolcat
echo -e "Host/IP        : ${domain}" | lolcat
echo -e "port           : 443" | lolcat
echo -e "Key            : ${user}" | lolcat
echo -e "Path           : /GABROK" | lolcat
echo -e "=================================" | lolcat
echo -e "Trojan-GO Link : ${trojangolink}" | lolcat
echo -e "=================================" | lolcat
echo -e "Expired On     : $exp" | lolcat
echo -e "=================================" | lolcat
echo -e "  °Script Mod By GABROK° " | lolcat
echo -e "=================================" | lolcat
