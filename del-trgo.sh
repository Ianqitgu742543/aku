#!/bin/bash
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/usr/local/etc/xray/trojanws.json")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		echo ""
		echo "You have no existing clients!"
		exit 1
	fi

	clear
	echo ""
	echo " Select the existing client you want to remove"
	echo " Press CTRL+C to return"
	echo " ==============================="
	echo "     No  Expired   User"
	grep -E "^### " "/usr/local/etc/xray/trojanws.json" | cut -d ' ' -f 2-3 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
			read -rp "Select one client [1]: " CLIENT_NUMBER
		else
			read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
user=$(grep -E "^### " "/usr/local/etc/xray/trojanws.json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### " "/usr/local/etc/xray/trojanws.json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
sed -i "/^### $user $exp/,/^/d" /usr/local/etc/xray/trojanws.json
sed -i '/^,"'"$user"'"$/d' /usr/local/etc/xray/trojanws.json
systemctl restart trojan-go
systemctl restart xray@trojanws
clear
cat /usr/bin/bannerku | lolcat
echo " Akun Trojan-Go berhasil dihapus" | lolcat
echo " ==============================" | lolcat
echo " Client Name : $user" | lolcat
echo " Expired On  : $exp" | lolcat
echo " ==============================" | lolcat
echo " °Script Mod By GABROK°" | lolcat
echo " ==============================" | lolcat
