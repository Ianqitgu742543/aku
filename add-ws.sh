#!/bin/bash
RED='\e[1;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
NC='\e[0m'
MYIP=$(wget -qO- ipinfo.io/ip);

clear
source /var/lib/premium-script/ipvps.conf
domain=$(cat /etc/v2ray/domain)
read -rp "Username: " -e user
egrep -w "^### Vmess $user" /etc/nginx/conf.d/vps.conf >/dev/null
if [ $? -eq 0 ]; then
echo "Username already used"
exit 0
fi
PORT=$((RANDOM + 10000))
read -p "Expired (days): " masaaktif
uuid=$(cat /proc/sys/kernel/random/uuid)
uid=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 14; echo;)
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
now=`date +"%Y-%m-%d"`
cat> /usr/local/etc/xray/vmess-$user.json<<END
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
      "tag": "vmess-in",
      "protocol": "vmess",
      "settings": {
        "clients": [
        {
            "id": "${uuid}",
            "alterId": 0
          }
        ]
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
          "vmess-in"
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
sed -i '$ i### Vmess '"$user"' '"$exp"'' /etc/nginx/conf.d/vps.conf
sed -i '$ ilocation /GABROK@u='"$user"'&p='"$uid"'&' /etc/nginx/conf.d/vps.conf
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
tls=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/GABROK@u=${user}&p=${uid}&",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF`
none=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "80",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/GABROK@u=${user}&p=${uid}&",
      "type": "none",
      "host": "${domain}",
      "tls": "none"
}
EOF`

cat>/etc/xray/$user-cfg.json<<EOF
[
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/GABROK@u=${user}&p=${uid}&",
      "type": "none",
      "host": "${domain}",
      "tls": "tls"
     }
     ],
     [
     {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "80",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/GABROK@u=${user}&p=${uid}&",
      "type": "none",
      "host": "${domain}",
      "tls": "none"
     }
]
EOF

#cat>/etc/v2ray/user/$user-tls.json
#echo "{uuid $uid" > /etc/v2ray/user/$user-tls.txt
vmesslink1="vmess://$(echo $tls | base64 -w 0)"
vmesslink2="vmess://$(echo $none | base64 -w 0)"
#echo $vmesslink1 > /etc/v2ray/user/$user-tls.json
systemctl start xray@vmess-$user
systemctl enable xray@vmess-$user
#sleep2
systemctl reload nginx
clear
echo -e ""
cat /usr/bin/bannerku | lolcat
echo -e "============-XRAY/VMESS================" | lolcat
echo -e "Remarks        : ${user}" | lolcat
echo -e "Domain         : ${domain}" | lolcat
echo -e "port TLS       : 443" | lolcat
echo -e "port none TLS  : 80" | lolcat
echo -e "id             : ${uuid}" | lolcat
echo -e "alterId        : 0" | lolcat
echo -e "Security       : auto" | lolcat
echo -e "network        : ws" | lolcat
echo -e "path           : /GABROK@u=${user}&p=${uid}&" | lolcat
echo -e "=================================" | lolcat
echo -e "link TLS       : ${vmesslink1}" | lolcat
echo -e "=================================" | lolcat
echo -e "link none TLS  : ${vmesslink2}" | lolcat
echo -e "=================================" | lolcat
echo -e "Expired On     : $exp" | lolcat
echo -e "=================================" | lolcat
echo -e "°  Script Mod By GABROK°" | lolcat
echo -e "=================================" | lolcat
