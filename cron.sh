#!/bin/bash
#     <3ms - [Good]
#     3ms> <6ms - [Warning]
#     > 6ms - [Critical]
MAIL_FROM="`hostname`@yourcompany.com"
MAIL_TO="louis@yourcompany.com"
MASTER_ID=""
MYSQL_USER=""
MYSQL_PASS=""

Warningthreshold=3
Criticalthreshold=6
Maximum_notification=3

CMD=$(pt-heartbeat -D test --check -h localhost --master-server-id=$MASTER_ID -u $MYSQL_USER -p $MYSQL_PASS | cut -d. -f1)
if [ $CMD -lt $Warningthreshold ]
then
MESSAGE=`date +'%m:%d:%Y %H:%M:%S'`" [Good] current delay: "$CMD;

rm -rf /tmp/monitor_mysql_slave_cron_Maximum_notification_Warning
rm -rf /tmp/monitor_mysql_slave_cron_Maximum_notification_Critical
rm -rf /tmp/monitor_mysql_slave_cron_Maximum_notification_Error

echo "rm -rf /tmp/monitor_mysql_slave_cron_Maximum_notification_Warning"
echo "rm -rf /tmp/monitor_mysql_slave_cron_Maximum_notification_Critical"
echo "rm -rf /tmp/monitor_mysql_slave_cron_Maximum_notification_Error"

if [ ! -f "/tmp/monitor_mysql_slave_cron_Maximum_notification_Good" ];then
	echo 1 > /tmp/monitor_mysql_slave_cron_Maximum_notification_Good
else
	notification_time=`cat /tmp/monitor_mysql_slave_cron_Maximum_notification_Good`
	echo $notification_time+1|bc > /tmp/monitor_mysql_slave_cron_Maximum_notification_Good
fi




elif [ $CMD -gt $Warningthreshold ] && [ $CMD -lt $Criticalthreshold ]
then
MESSAGE=`date +'%m:%d:%Y %H:%M:%S'`" [Warning] current delay: "$CMD;
rm -rf /tmp/monitor_mysql_slave_cron_Maximum_notification_Good
rm -rf /tmp/monitor_mysql_slave_cron_Maximum_notification_Critical
rm -rf /tmp/monitor_mysql_slave_cron_Maximum_notification_Error

echo "rm -rf /tmp/monitor_mysql_slave_cron_Maximum_notification_Good"
echo "rm -rf /tmp/monitor_mysql_slave_cron_Maximum_notification_Critical"
echo "rm -rf /tmp/monitor_mysql_slave_cron_Maximum_notification_Error"

if [ ! -f "/tmp/monitor_mysql_slave_cron_Maximum_notification_Warning" ];then
	echo 1 > /tmp/monitor_mysql_slave_cron_Maximum_notification_Warning
else
	notification_time=`cat /tmp/monitor_mysql_slave_cron_Maximum_notification_Warning`
	echo $notification_time+1|bc > /tmp/monitor_mysql_slave_cron_Maximum_notification_Warning
fi

elif [ $CMD -gt $Criticalthreshold ]
then
MESSAGE=`date +'%m:%d:%Y %H:%M:%S'`" [Critical] current delay: $CMD Check the replication"

rm -rf /tmp/monitor_mysql_slave_cron_Maximum_notification_Good
rm -rf /tmp/monitor_mysql_slave_cron_Maximum_notification_Warning
rm -rf /tmp/monitor_mysql_slave_cron_Maximum_notification_Error

echo "rm -rf /tmp/monitor_mysql_slave_cron_Maximum_notification_Good"
echo "rm -rf /tmp/monitor_mysql_slave_cron_Maximum_notification_Warning"
echo "rm -rf /tmp/monitor_mysql_slave_cron_Maximum_notification_Error"


if [ ! -f "/tmp/monitor_mysql_slave_cron_Maximum_notification_Critical" ];then
	echo 1 > /tmp/monitor_mysql_slave_cron_Maximum_notification_Critical
else
	notification_time=`cat /tmp/monitor_mysql_slave_cron_Maximum_notification_Critical`
	echo $notification_time+1|bc > /tmp/monitor_mysql_slave_cron_Maximum_notification_Critical
fi

else
MESSAGE=`date +'%m:%d:%Y %H:%M:%S'`" [Error] Replication status check failed need to investigate."

rm -rf /tmp/monitor_mysql_slave_cron_Maximum_notification_Good
rm -rf /tmp/monitor_mysql_slave_cron_Maximum_notification_Warning
rm -rf /tmp/monitor_mysql_slave_cron_Maximum_notification_Critical

echo "rm -rf /tmp/monitor_mysql_slave_cron_Maximum_notification_Good"
echo "rm -rf /tmp/monitor_mysql_slave_cron_Maximum_notification_Warning"
echo "rm -rf /tmp/monitor_mysql_slave_cron_Maximum_notification_Critical"

if [ ! -f "/tmp/monitor_mysql_slave_cron_Maximum_notification_Error" ];then
	echo 1 > /tmp/monitor_mysql_slave_cron_Maximum_notification_Error
else
	notification_time=`cat /tmp/monitor_mysql_slave_cron_Maximum_notification_Error`
	echo $notification_time+1|bc > /tmp/monitor_mysql_slave_cron_Maximum_notification_Error
fi
fi
#No arguments supplied"

if [ -f "/tmp/monitor_mysql_slave_cron_Maximum_notification_Good" ]; then
	Good_time=`cat /tmp/monitor_mysql_slave_cron_Maximum_notification_Good`
else
	Good_time=9999
fi

if [ -f "/tmp/monitor_mysql_slave_cron_Maximum_notification_Error" ]; then
	Error_time=`cat /tmp/monitor_mysql_slave_cron_Maximum_notification_Error`
else
	Error_time=9999
fi

if [ -f "/tmp/monitor_mysql_slave_cron_Maximum_notification_Critical" ]; then
	Critical_time=`cat /tmp/monitor_mysql_slave_cron_Maximum_notification_Critical`
else
	Critical_time=9999
fi

if [ -f "/tmp/monitor_mysql_slave_cron_Maximum_notification_Warning" ]; then
	Warning_time=`cat /tmp/monitor_mysql_slave_cron_Maximum_notification_Warning`
else
	Warning_time=9999
fi

if [ $Good_time -eq 1 ] || [ $Error_time -le $Maximum_notification ] || [ $Critical_time -le $Maximum_notification ] || [ $Warning_time -le $Maximum_notification ];
then
echo -e "To: $MAIL_TO\nFrom: <$MAIL_FROM>\nSubject: Replication status on `hostname`\n\nReplication status : $MESSAGE" | sendmail -t
echo "has sent email to $MAIL_TO"

fi

echo $MESSAGE