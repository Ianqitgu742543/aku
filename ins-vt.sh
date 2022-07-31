#!/bin/bash
domain=$(cat /root/domain)
apt install iptables iptables-persistent -y
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 
apt install socat cron bash-completion ntpdate -y
ntpdate pool.ntp.org
apt -y install chrony
timedatectl set-ntp true
systemctl enable chronyd && systemctl restart chronyd
systemctl enable chrony && systemctl restart chrony
timedatectl set-timezone Asia/Jakarta
chronyc sourcestats -v
chronyc tracking -v
date

mkdir -p /etc/trojan/
touch /etc/trojan/akun.conf
# install v2ray
wget https://raw.githubusercontent.com/Ianqitgu742543/aku/main/go.sh && chmod +x go.sh && ./go.sh
rm -f /root/go.sh
bash -c "$(wget -O- https://raw.githubusercontent.com/trojan-gfw/trojan-quickstart/master/trojan-quickstart.sh)"
#cert
mail=$(</dev/urandom tr -dc a-z0-9 | head -c4)
email=${mail}@gmail.com
mkdir /root/.acme.sh
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --register-account -m $email
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/v2ray/v2ray.crt --keypath /etc/v2ray/v2ray.key --ecc
service squid start
uuid=$(cat /proc/sys/kernel/random/uuid)
cat <<EOF > /etc/trojan/config.json
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": 443,
    "remote_addr": "127.0.0.1",
    "remote_port": 80,
    "password": [
        "password"
    ],
    "log_level": 1,
    "ssl": {
        "cert": "/etc/v2ray/v2ray.crt",
        "key": "/etc/v2ray/v2ray.key",
        "key_password": "",
        "cipher": "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384",
        "cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
        "prefer_server_cipher": true,
        "alpn": [
            "http/1.1"
        ],
        "alpn_port_override": {
            "h2": 81
        },
        "reuse_session": true,
        "session_ticket": false,
        "session_timeout": 600,
        "plain_http_response": "",
        "curves": "",
        "dhparam": ""
    },
    "tcp": {
        "prefer_ipv4": false,
        "no_delay": true,
        "keep_alive": true,
        "reuse_port": false,
        "fast_open": false,
        "fast_open_qlen": 20
    },
    "mysql": {
        "enabled": false,
        "server_addr": "127.0.0.1",
        "server_port": 3306,
        "database": "trojan",
        "username": "trojan",
        "password": "",
        "key": "",
        "cert": "",
        "ca": ""
    }
}
EOF
cat <<EOF> /etc/systemd/system/trojan.service
[Unit]
Description=Trojan
Documentation=https://trojan-gfw.github.io/trojan/

[Service]
Type=simple
ExecStart=/usr/local/bin/trojan -c /etc/trojan/config.json -l /var/log/trojan.log
Type=simple
KillMode=process
Restart=no
RestartSec=42s

[Install]
WantedBy=multi-user.target

EOF

cat <<EOF > /etc/trojan/uuid.txt
$uuid
EOF
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 443 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 80 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload
systemctl daemon-reload
systemctl enable v2ray@none.service
systemctl start v2ray@none.service
systemctl enable v2ray@vless.service
systemctl start v2ray@vlessservice
systemctl enable v2ray@vnone.service
systemctl start v2ray@vnone.service
systemctl restart trojan
systemctl enable trojan
systemctl restart v2ray
systemctl enable v2ray
cd /usr/bin
wget -q -O add-ws "https://raw.githubusercontent.com/Ianqitgu742543/aku/main/add-ws.sh"
wget -q -O add-vless "https://raw.githubusercontent.com/Ianqitgu742543/aku/main/add-vless.sh"
wget -q -O add-tr "https://raw.githubusercontent.com/Ianqitgu742543/aku/main/add-tr.sh"
wget -q -O del-ws "https://raw.githubusercontent.com/Ianqitgu742543/aku/main/del-ws.sh"
wget -q -O del-vless "https://raw.githubusercontent.com/Ianqitgu742543/aku/main/del-vless.sh"
wget -q -O del-tr "https://raw.githubusercontent.com/Ianqitgu742543/aku/main/del-tr.sh"
wget -q -O cek-ws "https://raw.githubusercontent.com/Ianqitgu742543/aku/main/cek-ws.sh"
wget -q -O cek-vless "https://raw.githubusercontent.com/Ianqitgu742543/aku/main/cek-vless.sh"
wget -q -O cek-tr "https://raw.githubusercontent.com/Ianqitgu742543/aku/main/cek-tr.sh"
wget -q -O renew-ws "https://raw.githubusercontent.com/Ianqitgu742543/aku/main/renew-ws.sh"
wget -q -O renew-vless "https://raw.githubusercontent.com/Ianqitgu742543/aku/main/renew-vless.sh"
wget -q -O renew-tr "https://raw.githubusercontent.com/Ianqitgu742543/aku/main/renew-tr.sh"
wget -q -O certv2ray "https://raw.githubusercontent.com/Ianqitgu742543/aku/main/cert.sh"
wget -q -O add-trgo "https://raw.githubusercontent.com/Ianqitgu742543/aku/main/add-trgo.sh"
wget -q -O del-trgo "https://raw.githubusercontent.com/Ianqitgu742543/aku/main/del-trgo.sh"
wget -q -O bannerku "https://raw.githubusercontent.com/Ianqitgu742543/aku/main/bannerku"
wget -q -O menu "https://raw.githubusercontent.com/Ianqitgu742543/aku/main/menu.sh"
wget -q -O xpvmess "https://raw.githubusercontent.com/Ianqitgu742543/aku/main/xpvmess.sh"
wget -q -O xpvless "https://raw.githubusercontent.com/Ianqitgu742543/aku/main/xpvless.sh"
wget -q -O xptrgo "https://raw.githubusercontent.com/Ianqitgu742543/aku/main/xp-trgo.sh"
chmod +x add-ws
chmod +x add-vless
chmod +x add-tr
chmod +x del-ws
chmod +x del-vless
chmod +x del-tr
chmod +x cek-ws
chmod +x cek-vless
chmod +x cek-tr
chmod +x renew-ws
chmod +x renew-vless
chmod +x renew-tr
chmod +x certv2ray
chmod +x add-trgo
chmod +x del-trgo
chmod +x xpvmess
chmod +x xpvless
chmod +x bannerku
chmod +x xptrgo
chmod +x menu && sed -i -e 's/\r$//' menu
echo "0 0 * * * root xpvmess" >> /etc/crontab
echo "0 0 * * * root xpvless" >> /etc/crontab
echo "0 0 * * * root xptrgo" >> /etc/crontab

#enc
shc -r -f add-ws -o add-ws
shc -r -f add-vless -o add-vless
shc -r -f add-tr -o add-tr
shc -r -f del-ws -o del-ws
shc -r -f del-vless -o del-vless
shc -r -f del-tr -o del-tr
shc -r -f cek-ws -o cek-ws
shc -r -f cek-vless -o cek-vless
shc -r -f cek-tr -o cek-tr
shc -r -f renew-ws -o renew-ws
shc -r -f renew-vless -o renew-vless
shc -r -f renew-tr -o renew-tr
shc -r -f certv2ray -o certv2ray
shc -r -f add-trgo -o add-trgo
shc -r -f del-trgo -o del-trgo
shc -r -f xpvmess -o xpvmess
shc -r -f xpvless -o xpvless
shc -r -f xptrgo -o xptrgo
shc -r -f menu -o menu
cd
rm -f ins-vt.sh
mv /root/domain /etc/v2ray
cd
