#!/bin/bash
###############

app_name="badboy"
app_name_short="bd"
app_name2="badbadboy"
node="node.baidu.com"
domain="mirror.baidu.com"
password="2beNo.1"

###############
apt update && apt upgrade -y
# optional
# apt install ${app_name}-libev -y

## badbadboy-plugin
wget https://github.com/${app_name}/${app_name2}-plugin/releases/download/v1.3.2/${app_name2}-plugin-linux-amd64-v1.3.2.tar.gz
tar xf ${app_name2}-plugin-linux-amd64-v1.3.2.tar.gz
mv ${app_name2}-plugin_linux_amd64 /usr/bin/${app_name2}-plugin
chmod +x /usr/bin/${app_name2}-plugin

echo -e "
[Unit]
Description=${app_name}-Libev Custom Client Service for %I
Documentation=man:${app_name_short}-local(1)
After=network-online.target

[Service]
Type=simple
CapabilityBoundingSet=CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_BIND_SERVICE
DynamicUser=true
ExecStart=/usr/bin/${app_name_short}-local -c /etc/${app_name}-libev/%i.json

[Install]
WantedBy=multi-user.target
"> /lib/systemd/system/${app_name}-libev-local@.service
systemctl daemon-reload

## badboy-libev config file
echo '
{
    "server":["127.0.0.1"],
    "mode":"tcp_and_udp",
    "server_port":8388,
    "local_port":1080,
    "password":"'${password}'",
    "timeout":86400,
    "method":"aes-256-gcm",
    "plugin": "/usr/bin/${app_name2}-plugin",
    "plugin_opts": "server;path=/ws"
}
' > /etc/${app_name}-libev/config.json

echo -e "{
 \"server\":\"${node}\",
 \"server_port\":8388,
 \"local_address\":\"127.0.0.1\",
 \"local_port\":1080,
 \"password\":\"focobguph\",
 \"timeout\":60,
 \"method\":\"aes-256-gcm\",
 \"plugin\":\"/usr/bin/${app_name2}-plugin\",
 \"plugin_opts\":\"tls;host=${domain};path=/ws\",
}" >> /etc/${app_name}-libev/client.json
systemctl enable ${app_name}-libev-local@client.service
systemctl start ${app_name}-libev-local@client.service