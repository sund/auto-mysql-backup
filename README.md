## auto-mysql-backup

*My custom version*

---

in automysqlbackup script, there is:

```
CONFIG_configfile="/etc/automysqlbackup/automysqlbackup.conf"
```

that can be changed if needed. I managed to just pass in the conf file on the command line

```bash
5 3 * * * /usr/local/sbin/auto-mysql-backup/automysqlbackup /usr/local/sbin/auto-mysql-backup/automysqlbackup.conf
```

#### Future

Use ```runmysqlbackup.sh``` as a wrapper to run the script, picking up the paths we start from, etc.