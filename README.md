Your need Install pt-heartbeat tools on your master and slave



# For CentOS 7 Guide
```
yum install perl-TermReadKey perl-Digest-MD5 perl-IO-Socket-SSL perl-DBD-MySQL perl-DBI -y

wget https://www.percona.com/downloads/percona-toolkit/3.0.6/binary/redhat/7/x86_64/percona-toolkit-3.0.6-1.el7.x86_64.rpm

rpm -ivh percona-toolkit-3.0.6-1.el7.x86_64.rpm
```


- On Master run:
```
pt-heartbeat -D test --update -h localhost --user mysqluser --password mysqlpassword --create-table --daemonize
```




- On Slave run test:

```
pt-heartbeat -D test --check -h localhost --master-server-id=100 -u mysqluser -p mysqlpassword
```


- Example output like:


```
[root@mysql2 ~]# pt-heartbeat -D test --check -h localhost --master-server-id=100 -u root -p root
0.00
```


Download monitor script
```
wget https://raw.githubusercontent.com/holinhot/Mysql_master_slave_delay_monitor/master/cron.sh
```

Configuration into script:
```
MAIL_FROM="`hostname`@yourcompany.com"
MAIL_TO="louis@yourcompany.com"
MASTER_ID=""
MYSQL_USER=""
MYSQL_PASS=""

Warningthreshold=3
Criticalthreshold=6
Maximum_notification=3
```


- create a crontab task Run every minute
```
* * * * * /script/cron.sh
```
