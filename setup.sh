#!/bin/bash
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
if [ -f "/etc/v2ray/domain" ]; then
echo "Script Already Installed"
exit 0
fi
mkdir /etc/v2ray
clear
wget -q https://raw.githubusercontent.com/Ianqitgu742543/aku/main/cf.sh && chmod +x cf.sh && ./cf.sh
#install path
wget -q https://raw.githubusercontent.com/Ianqitgu742543/aku/main/path.sh && chmod +x path.sh && screen -S path ./path.sh
#install v2ray
wget -q https://raw.githubusercontent.com/Ianqitgu742543/aku/main/ins-vt.sh && chmod +x ins-vt.sh && screen -S v2ray ./ins-vt.sh
wget -q https://raw.githubusercontent.com/Ianqitgu742543/aku/main/xray.sh && chmod +x xray.sh && ./xray.sh
wget -q https://raw.githubusercontent.com/Ianqitgu742543/aku/main/set-br.sh && chmod +x set-br.sh && ./set-br.sh

rm -f /root/path.sh
rm -f /root/ins-vt.sh
rm -f /root/set-br.sh
rm -f /root/install.sh
rm -f /root/xray.sh

cat > /usr/bin/bersih << END
#!/bin/bash
echo 1 > /proc/sys/vm/drop_caches
echo 2 > /proc/sys/vm/drop_caches
echo 3 > /proc/sys/vm/drop_caches
swapoff -a
swapon -a
ban
clear-log
END
chmod +x /usr/bin/bersih

domain=$(cat /etc/v2ray/domain)
uid=$(cat /etc/trojan/uuid.txt)
cat>/usr/local/etc/xray/trojanws.json<<EOF
{
  "log": {
    "access": "/var/log/xray/trojanws.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 32181,
      "protocol": "trojan",
      "settings": {
        "clients": [
          {
            "id": "$uid"
#tls
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/Jhons",
          "headers": {
            "Host": ""
          }
         },
        "quicSettings": {},
        "sockopt": {
          "mark": 0,
          "tcpFastOpen": true
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "domain": "$domain"
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
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
EOF
systemctl start xray@trojanws
systemctl enable xray@trojanws
systemctl restart xray@trojanws

cat <<EOF> /etc/systemd/system/autosett.service
[Unit]
Description=autosetting
Documentation=https://vpnstores.net

[Service]
Type=oneshot
ExecStart=/bin/bash /etc/set.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable autosett
wget -q -O /etc/set.sh "https://raw.githubusercontent.com/Ianqitgu742543/caxacacacacaxl/main/set.sh"
chmod +x /etc/set.sh
history -c && history -w
echo "1.2" > /home/ver
clear
echo " "
echo "Installation has been completed!!"
echo " "
echo "=================================-Autoscript Premium-===========================" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "--------------------------------------------------------------------------------" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Service & Port"  | tee -a log-install.txt
echo "   - Squid Proxy             : 3128, 8080 (limit to IP Server)"  | tee -a log-install.txt
echo "   - Badvpn                  : 7100, 7200, 7300"  | tee -a log-install.txt
echo "   - Nginx                   : 81"  | tee -a log-install.txt
echo "   - Xray Vmess TLS         : 443"  | tee -a log-install.txt
echo "   - Xray Vmess None TLS    : 80"  | tee -a log-install.txt
echo "   - Xray Vless TLS         : 443"  | tee -a log-install.txt
echo "   - Xray Vless None TLS    : 80"  | tee -a log-install.txt
echo "   - Trojan                  : 443"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Server Information & Other Features"  | tee -a log-install.txt
echo "   - Timezone                : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "   - Fail2Ban                : [ON]"  | tee -a log-install.txt
echo "   - Dflate                  : [ON]"  | tee -a log-install.txt
echo "   - IPtables                : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot             : [ON]"  | tee -a log-install.txt
echo "   - IPv6                    : [OFF]"  | tee -a log-install.txt
echo "   - Autoreboot On 05.00 GMT +7" | tee -a log-install.txt
echo "   - Autobackup Data" | tee -a log-install.txt
echo "   - Restore Data" | tee -a log-install.txt
echo "   - Auto Delete Expired Account" | tee -a log-install.txt
echo "   - Full Orders For Various Services" | tee -a log-install.txt
echo "   - White Label" | tee -a log-install.txt
echo "   - Installation Log --> /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "-----------------------------------------------------------------------------------------------------------------------------" | tee -a log-install.txt
echo ""
echo " Reboot 15 Sec"
history -c
sleep 15
rm -f setup.sh
reboot

