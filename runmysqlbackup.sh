#!/bin/bash

###
## Variables/settings
#

PDIR=$(dirname $(readlink -f $0))
confFile="$PDIR/runmysqlbackup.conf"

# unless overriden in the conffile, here are some defaults
localBackupDir="/backups/mysql"
toggleRemoteCopy=0

###
## Functions
#

checkSize() {
    echo ===== Sizing =====
    echo "Total disk space used for backup storage.."
    echo "Size - Location"
    echo `du -hs "$localBackupDir"`
    echo
}

parseVerifyConf() {
	if [ -e $confFile -a -r $confFile ]
	then
		source $confFile
		echo "Parsing config file..."
		toggleRemoteCopy=1
	else
		echo "No confFile found; Remote copy DISABLED."
	fi

}

findAutoMyB() {
	if [ -e $PDIR/automysqlbackup -a -x $PDIR/automysqlbackup ]
	then
		binPath="$PDIR/automysqlbackup"
	else
		if [ -e /usr/local/bin/automysqlbackup -a -x /usr/local/bin/automysqlbackup ]
		then
			binPath="/usr/local/bin/automysqlbackup"
		else
			echo "Couldn't find the automysqlbackup script."
			exit 1
		fi
	fi

}

findConfAMB() {
	if [ -e $PDIR/automysqlbackup.conf -a -r $PDIR/automysqlbackup.conf ]
	then
		confPath="$PDIR/automysqlbackup.conf"
	else
		if [ -e /etc/automysqlbackup/automysqlbackup.conf -a -r /etc/automysqlbackup/automysqlbackup.conf ]
		then
			confPath="/etc/automysqlbackupautomysqlbackup.conf"
		else
			echo "Couldn't find the automysqlbackup config."
			exit 1
		fi
	fi
}

runAMB() {
## /usr/local/sbin/automysqlbackup /etc/automysqlbackup/myserver.conf
$binPath $confPath
}

chownLocal() {
# do we need to chown things?

chown root.root $localBackupDir -R
find /var/backup/db* -type f -exec chmod 400 {} \;
find /var/backup/db* -type d -exec chmod 700 {} \;

}

rsyncUp() {
# rsync up with default key
    echo =============================================================
    echo Start rsync to rsync.net/backup no key
    echo =============================================================
    rsync -Cavz --delete-after -e "ssh -p$remotePort" $localBackupDir/ $remoteUser@$remoteServer:$remoteDest
}

rsyncKey() {
# rsync up with specific key
    echo =============================================================
    echo Start rsync to rsync.net/backup with specific key
    echo =============================================================
    rsync -Cavz --delete-after -e "ssh -i $sshKeyPath -p$remotePort" $localBackupDir/ $remoteUser@$remoteServer:$remoteDest
}

rsyncDaemon() {
# rsync up with specific key
    echo =============================================================
    echo Start rsync to rsync.net/backup in daemon mode
    echo =============================================================
    rsync -Cavz --port=$remotePort --password-file=$rsync_password_file --delete-after /$localBackupDir/ $remoteUser@$remoteServer::$remoteModule
}

printScriptver() {
	# print the most recent tag
	echo "This is $0"
	cd $PDIR
	echo "Version $(git describe --abbrev=0 --tags), commit #$(git log --pretty=format:'%h' -n 1)."
}

###
## Work
#

## parse the config file
parseVerifyConf

# find the automysqlbackup script in this directory and run
# if we can't find it maybe it is in /usr/local/bin ??
findAutoMyB

## find the conf file here or in /etc/ or /etc/automysqlbackup??
findConfAMB

## Run the scripts
runAMB

## chown local copies, if needed
#chownLocal

## size the local copy
checkSize

## rsync local to remote

if [[ $toggleRemoteCopy -eq 1 ]]
then
	if [[ $remoteModule != "" ]]
	then
		rsyncDaemon
	
	# no Daemon so lets see if we are using a special key
	else if [ -e $sshKeyPath -a -r $sshKeyPath ] && [[ $sshKeyPath != "" ]]
		then
		
			rsyncKey
		else if [[ $remoteServer != "" ]]
		then
			# use the defualt 
			rsyncUp
			fi
		fi
	fi
fi
# Print version
printScriptver

###
## Done
#
