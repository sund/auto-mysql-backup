#!/bin/sh

/usr/local/sbin/automysqlbackup /etc/automysqlbackup/myserver.conf

chown root.root /var/backup/db* -R
find /var/backup/db* -type f -exec chmod 400 {} \;
find /var/backup/db* -type d -exec chmod 700 {} \;
