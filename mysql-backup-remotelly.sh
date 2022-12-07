#!/bin/bash

dbname="hadoken"

hostname="web"
hostuser="root"
path_local="/opt/db/"

days_keep=7

#######################
tmp_zipfile="/tmp/d.sql.gz"

ssh -n $hostuser@$hostname "mysqldump ${dbname} | gzip > ${tmp_zipfile}"
if [[ $? -ne 0 ]]; then
    echo "backup remotelly failed"
    exit 1
fi

mkdir -p $path_local
scp -rp $hostuser@$hostname:${tmp_zipfile} ${path_local}/${dbname}-$(date +"%Y%m%d-%H%M%S").sql.gz
find $path_local -mtime +$days_keep -type f -exec rm -i {} \;

ssh -n $hostuser@$hostname "rm -f ${tmp_zipfile}"