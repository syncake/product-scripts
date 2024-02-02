#!/bin/bash

kasmpath='/root/Downloads/kasm_release'

cd $kasmpath
bash install.sh -p 127.0.0.1 \
                -L 50080 \
                --admin-password 'QWer@2023'

########################### 
# 1. adding setting to Access Managerment - Groups
# - keepalive_expiration: 8640000
# - keepalive_expiration_action: pause
# 2. Infrastructure - Zones, Edit, set Proxy Port to 0; means auto-detective
