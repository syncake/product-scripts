#!/bin/bash

docker run --name guacd \
    --restart unless-stopped \
    -d -p 127.0.0.1:4822:4822 guacamole/guacd
docker cp /usr/share/fonts/truetype guacd:/usr/share/fonts/

docker run --name guacamole \
    --link guacd:guacd  \
	--restart unless-stopped \
    -e MYSQL_HOSTNAME=172.17.0.1  \
    -e MYSQL_PORT=3306  \
    -e MYSQL_DATABASE=guacd  \
    -e MYSQL_USER=guacd    \
    -e MYSQL_PASSWORD='helloGuacd' \
    -d -p 127.0.0.1:8080:8080 guacamole/guacamole
