#!/bin/bash

date_str=$(date +%Y%m%d-%H)
group_name_ansible="cs"
mysql_dbname="hadoken"
path_remote="/tmp/db.sql.gz"
path_local="/opt/db-backup/${mysql_dbname}/"
backup_host="dbbak"
backup_path="/opt/dbbackup-${mysql_dbname}/${date_str}/"
backup_kept=7

/bin/rm -rf "${path_local}"
mkdir -p $path_local

ansible $group_name_ansible -m shell -a "mysqldump ${mysql_dbname} | gzip > ${path_remote}"
ansible $group_name_ansible -m fetch -a "src=${path_remote} flat='true' dest='${path_local}{{inventory_hostname}}.sql.gz' "
ansible $group_name_ansible -m shell -a "rm -f ${path_remote}"

# send to remote storage server
if [[ ! -z $backup_host ]]; then
    ssh $backup_host "sudo mkdir -p ${backup_path}; sudo chown -R \$(whoami) ${backup_path}"
    rsync -arPz $path_local $backup_host:$backup_path

    ssh $backup_host "find ${backup_path} -type f -mtime +${backup_kept} | xargs sudo rm -f"
fi