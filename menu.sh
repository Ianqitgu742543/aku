{}$red !/bin/bash
red="\e[1;31m"
gren="\e[1;32m"
blue="\e[1;34m"
yelow="\e[1;33m"
cyan="\e[1;36m"
white="\e[1;37m"
clear
echo -e ""
echo -e "$red════════════════════════════════════════════════════"
echo -e "$yelow═════════$white[Script Premium by Phreaker404]$yelow═════════"
echo -e "$gren════════════$white[t.me/NoSystemIsSafe]$gren═══════════"
echo -e "$blue════════════════════════════════════════════════════"
echo -e "$red═══════════════════════════════════════════════"
echo -e "$yelow══════════════$white[All Account V2Ray]$yelow══════════════"
echo -e "$gren═══════════════════════════════════════════════"
echo -e "$cyan══════════$white[V2Ray Vmess]$cyan═════════"
echo -e "$red  1.  $white Create Vmess Websocket Account"
echo -e "$red  2.  $white Delete Vmess Websocket Account"
echo -e "$red  3.  $white Renew Vmess Account Active Life"
echo -e "$red  4.  $white Check User Login Vmess"
echo -e "$cyan══════════$white[V2Ray Vless]$cyan═════════"
echo -e "$red  5.  $white Create Vless Websocket Account"
echo -e "$red  6.  $white Deleting Vless Websocket Account"
echo -e "$red  7.  $white Renew Vless Account Active Life "
echo -e "$red  8.  $white Check User Login Vless"
echo -e "$cyan════════════$white[Trojan]$cyan════════════"
echo -e "$red  9.  $white Create Trojan Account"
echo -e "$red  10.  $white Deleting Trojan Account"
echo -e "$red  11.  $white Renew Trojan Account Active Life"
echo -e "$red  12.  $white Check User Login Trojan"
echo -e "$red═══════════════════════════════════════════════"
echo -e "$yelow════════════$white[All System Untils Menu]$yelow═══════════"
echo -e "$gren═══════════════════════════════════════════════"
echo -e "$red  13.  $white Add Subdomain Host For VPS"
echo -e "$red  14.  $white Renew Certificate V2RAY"
echo -e "$red  15.  $white Change Port All Account"
echo -e "$red  16.  $white Autobackup Data VPS"
echo -e "$red  17.  $white Backup Data VPS"
echo -e "$red  18.  $white Restore Data VPS"
echo -e "$red  19.  $white Webmin Menu"
echo -e "$red  20.  $white Limit Bandwith Speed Server"
echo -e "$red  21.  $white Check Usage of VPS Ram"
echo -e "$red  22.  $white Reboot VPS"
echo -e "$red  23.  $white Speedtest VPS"
echo -e "$red  24.  $white Information Display System"
echo -e "$red  25.  $white Info Script Auto Install"
echo -e "$red  26.  $white Start SSH Websocket"
echo -e "$red  27.  $white Update Menu Terbaru
echo -e "$red═══════════════════════════════════════════"
echo -e "$red   0.  $white Exit From Putty / JuiceSSH / Termux"
echo -e "$gren═══════════════════════════════════════════"
echo -e ""
read -p "     Please Input Number  [1-27 or 0] :  " menu
echo -e ""
case $menu in
1)
add-ws
;;
2)
del-ws
;;
3)
renew-ws
;;
4)
cek-ws
;;
5)
add-vless
;;
6)
del-vless
;;
7)
renew-vless
;;
8)
cek-vless
;;
9)
add-tr
;;
10)
del-tr
;;
11)
renew-tr
;;
12)
cek-tr
;;
13)
add-host
;;
14)
certv2ray
;;
15)
change-port
;;
16)
autobackup
;;
17)
backup
;;
18)
restore
;;
19)
wbmn
;;
20)
limit-speed
;;
21)
ram
;;
22)
reboot
;;
23)
speedtest
;;
24)
info
;;
25)
about
;;
26)
systemctl start edu-proxy
;;
27)
update
;;
x)
exit
;;
*)
echo -e "$red Please enter an correct number!!!"
;;
esac
