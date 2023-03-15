#!/bin/bash

server_host="gateway.baidu.com"
iptables_port=443

local_ip=$(curl -Ls ipinfo.io | jq .ip | cut -d '"' -f2)

echo "adding local_ip:${local_ip} into iptables rule"
ssh $server_host "iptables -I INPUT -p tcp -s ${local_ip}/32 --dport ${iptables_port} -j ACCEPT"