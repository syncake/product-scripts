#!/bin/bash
###############

app_name="badboy"
app_name2="badbadboy"
domain="mirror.baidu.com"
password="2beNo.1"

###############
apt update && apt upgrade -y
apt install ${app_name}-libev nginx certbot wget -y

## badbadboy-plugin
wget https://github.com/${app_name}/${app_name2}-plugin/releases/download/v1.3.2/${app_name2}-plugin-linux-amd64-v1.3.2.tar.gz
tar xf ${app_name2}-plugin-linux-amd64-v1.3.2.tar.gz
mv ${app_name2}-plugin_linux_amd64 /usr/bin/${app_name2}-plugin
chmod +x /usr/bin/${app_name2}-plugin

echo -e "##
server {
	server_name ${domain};
	root /tmp;
}
" > /etc/nginx/sites-enabled/${app_name}.conf
service nginx reload

ufw allow 80
ufw allow 443

certbot certonly --webroot -d ${domain} -w /tmp
echo -e "
server {
	listen 443 ssl;
	ssl_certificate /etc/letsencrypt/live/${domain}/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/${domain}/privkey.pem;
	server_name ${domain};
	root /var/www/html;
	index index.html index.htm index.nginx-debian.html;
	location /ws {
		proxy_pass http://127.0.0.1:8388;
		proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \"Upgrade\";
	}
}" >> /etc/nginx/sites-enabled/${app_name}.conf
service nginx restart

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

systemctl restart ${app_name}-libev