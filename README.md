## auto-mysql-backup

Using _http://sourceforge.net/projects/automysqlbackup/_ with a wrapper that I
use. The main benefit is being able to rsync the backups to another server.

---

#### Usage

Clone with ```git clone https://github.com/sund/auto-mysql-backup.git``` in ```/usr/local/sbin```.

Use ```runmysqlbackup.sh``` as a wrapper to run the script.

#### edit the automysqlbackup config file

```cp automysqlbackup-sample.conf automysqlbackup.conf``` and edit as needed.

#### edit the runmysqlbackup.conf file

```cp runmysqlbackup-sample.conf runmysqlbackup.conf``` and enter your server info to rsync to.

#### Crontab entry

```bash
5 3 * * * /usr/local/sbin/auto-mysql-backup/runmysqlbackup.sh
```

#### et cetera

the folder ```_sf_distro``` has some extra files from the SourceForge download to keep things neat.

This uses version v3.0_rc6 of automysqlbackup