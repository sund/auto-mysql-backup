## auto-mysql-backup

*My custom version*

---

in automysqlbackup script, there is:

```
CONFIG_configfile="/etc/automysqlbackup/automysqlbackup.conf"
```

that can be changed if needed. I managed to just pass in the conf file on the command line

```/home/sundorg/sundRepo/Cronscripts/automysqlbackup/./automysqlbackup.sh /home/sundorg/sundRepo/Cronscripts/automysqlbackup/automysqlbackup.conf```