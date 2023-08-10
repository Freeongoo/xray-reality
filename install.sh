#!/bin/bash

# Update package index and install dependencies
sudo apt-get update
sudo apt-get install -y jq openssl qrencode

curl -s https://raw.githubusercontent.com/Freeongoo/xray-reality/master/default.json > config.json

# Extract the desired variables using jq
name=$(jq -r '.name' config.json)
path=$(jq -r '.path' config.json)

bash -c "$(curl -L https://raw.githubusercontent.com/XTLS/Xray-install/046d9aa2432b3a6241d73c3684ef4e512974b594/install-release.sh)" @ install --version 1.8.1

json=$(curl -s https://raw.githubusercontent.com/Freeongoo/xray-reality/master/config.json)

keys=$(xray x25519)
pk=$(echo "$keys" | awk '/Private key:/ {print $3}')
pub=$(echo "$keys" | awk '/Public key:/ {print $3}')
serverIp=$(curl -s ipv4.wtfismyip.com/text)
uuid=$(xray uuid)
shortId=$(openssl rand -hex 8)

url="vless://$uuid@$serverIp:443?type=http&security=reality&encryption=none&flow=xtls-rprx-vision&pbk=$pub&fp=chrome&path=$path&sni=www.microsoft.com&sid=$shortId#$name"

newJson=$(echo "$json" | jq \
    --arg pk "$pk" \
    --arg uuid "$uuid" \
    --arg shortId "$shortId" \
     .inbounds[0].settings.clients[0].id = $uuid |
     .inbounds[0].streamSettings.realitySettings.privateKey = $pk |
     .inbounds[0].streamSettings.realitySettings.shortIds += ["'$shortId'"]')

echo "$newJson" | sudo tee /usr/local/etc/xray/config.json >/dev/null
sudo systemctl restart xray

echo "$url"

qrencode -s 120 -t ANSIUTF8 "$url"
qrencode -s 50 -o qr.png "$url"

exit 0