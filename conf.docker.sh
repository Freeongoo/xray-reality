#!/bin/bash
json=$(curl -s https://raw.githubusercontent.com/Freeongoo/xray-reality/master/config.json)

keys=$(xray x25519)
pk=$(echo "$keys" | awk '/Private key:/ {print $3}')
pub=$(echo "$keys" | awk '/Public key:/ {print $3}')
serverIp=$(curl -s ifconfig.me)
uuid=$(xray uuid)
shortId=$(openssl rand -hex 8)
url="vless://$uuid@$serverIp:443?path=%2F&security=reality&encryption=none&pbk=$pub&fp=safari&type=tcp&sni=www.microsoft.com&sid=$shortId#REALITY"

newJson=$(echo "$json" | jq \
    --arg pk "$pk" \
    --arg uuid "$uuid" \
    --arg shortId "$shortId" \
    '.inbounds[0].streamSettings.realitySettings.privateKey = $pk | 
     .inbounds[0].settings.clients[0].id = $uuid |
     .inbounds[0].streamSettings.realitySettings.shortIds += ["'$shortId'"]')
sudo touch /home/config.json
echo "$newJson" | sudo tee /home/config.json >/dev/null

#sudo service xray restart

sudo xray run -config /home/config.json

echo "$url" >> /root/test.url

exit 0