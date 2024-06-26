#!/bin/bash
RED='\e[1;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
NC='\e[0m'
MYIP=$(wget -qO- ipinfo.io/ip);

clear 
domain=$(cat /etc/v2ray/domain)
read -rp "User: " -e user
egrep -w "^### Vless $user" /etc/nginx/conf.d/vps.conf >/dev/null
if [ $? -eq 0 ]; then
echo -e "Username Sudah Ada"
exit 0
fi
PORT=$((RANDOM + 10000))
read -p "Expired (days): " masaaktif
uuid=$(cat /proc/sys/kernel/random/uuid)
uid=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 14; echo;)
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
now=`date +"%Y-%m-%d"`
cat> /usr/local/etc/xray/vless-$user.json<<END
{
  "log": {
        "access": "/var/log/xray/access.log",
        "error": "/var/log/xray/error.log",
        "loglevel": "warning"
    },
  "inbounds": [
    {
      "port":$PORT,
      "listen": "127.0.0.1", 
      "tag": "VLESS-in", 
      "protocol": "VLESS", 
      "settings": {
        "clients": [
          {
            "id": "$uuid"
          }
        ],
	    "decryption": "none"
      }, 
      "streamSettings": {
        "network": "ws", 
        "wsSettings": {
        "path":"/GABROK@u=$user&p=$uid&"
        }
      }
    }
  ], 
  "outbounds": [
    {
      "protocol": "freedom", 
      "settings": { }, 
      "tag": "direct"
    }, 
    {
      "protocol": "blackhole", 
      "settings": { }, 
      "tag": "blocked"
    }
  ], 
  "dns": {
    "servers": [
      "https+local://1.1.1.1/dns-query",
	  "1.1.1.1",
	  "1.0.0.1",
	  "8.8.8.8",
	  "8.8.4.4",
	  "localhost"
    ]
  },
  "routing": {
    "domainStrategy": "AsIs",
    "rules": [
      {
        "type": "field",
        "inboundTag": [
          "VLESS-in"
        ],
        "outboundTag": "direct"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  }
}
END
sed -i '$ i### Vless '"$user"' '"$exp"'' /etc/nginx/conf.d/vps.conf
sed -i '$ ilocation /GABROKu='"$user"'&p='"$uid"'&' /etc/nginx/conf.d/vps.conf
sed -i '$ i{' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_pass http://127.0.0.1:'"$PORT"';' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/vps.conf
sed -i '$ i}' /etc/nginx/conf.d/vps.conf
vlesslink1="vless://${uuid}@${domain}:443/?tyepe=ws&encryption=none&host=bug.com&path=%2FGABROK@u%3D${user}%26p%3D${uid}%26&security=tls&encryption=none&type=ws#${user}"
vlesslink2="vless://${uuid}@${domain}:80?path=%2FGABROK@u%3D${user}%26p%3D${uid}%26&encryption=none&type=ws#${user}"
systemctl start xray@vless-$user
systemctl enable xray@vless-$user
echo -e "\033[32m[Info]\033[0m Xray-Vless Start Successfully !"
sleep 2
systemctl reload nginx
clear
echo -e ""
cat /usr/bin/bannerku | lolcat
echo -e "==========-X2RAY/VLESS-==========" | lolcat
echo -e "Remarks        : ${user}" | lolcat
echo -e "Domain         : ${domain}" | lolcat
echo -e "port TLS       : 443" | lolcat
echo -e "port none TLS  : 80" | lolcat
echo -e "id             : ${uuid}" | lolcat
echo -e "alterId        : 2" | lolcat
echo -e "Security       : auto" | lolcat
echo -e "network        : ws" | lolcat
echo -e "path           : /GABROK@u=${user}&p=${uid}&" | lolcat
echo -e "=================================" | lolcat
echo -e "link TLS       : ${vlesslink1}" | lolcat
echo -e "=================================" | lolcat
echo -e "link none TLS  : ${vlesslink2}" | lolcat
echo -e "=================================" | lolcat
echo -e "Created        : $now" | lolcat
echo -e "Expired On     : $exp" | lolcat
echo -e "=================================" | lolcat
echo -e "  °Script Mod By GABROK° " | lolcat
echo -e "=================================" | lolcat
