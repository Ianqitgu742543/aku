#!/bin/bash
data=( `cat /usr/local/etc/xray/trojanws.json | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^### $user" "/usr/local/etc/xray/trojanws.json" | cut -d ' ' -f 3)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" = "0" ]]; then
sed -i "/^### $user $exp/,/^/d" "/usr/local/etc/xray/trojanws.json"
sed -i '/^,"'"$user"'"$/d' /usr/local/etc/xray/trojanws.json
fi
done
systemctl restart xray@trojanws
