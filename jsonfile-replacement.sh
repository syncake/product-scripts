#!/usr/bin/env bash

config_file="/etc/niubi/config.json"
port_target=1$(date +%m%d)

which ufw
if [[ $? -eq 0 ]]; then
  ufw allow $port_target

  port_previous = $(grep 'server_port' $config_file | cut -d ':' -f 2 | awk '{print $NF}' | cut -d ',' -f 1)
  if test -z $port_previous; then
    ufw delete allow $port_target
  fi
fi

/usr/bin/sed -i 's/\"server_port\":\s*[0-9]\+/\"server_port\": '$port_target'/'
