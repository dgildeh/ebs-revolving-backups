#!/bin/sh
# $1 = volume, $2 = number of snapshots to keep
# Set Environment Variables as cron doesn't load them
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/jre
export EC2_HOME=/usr/local/ec2/ec2-api-tools-1.7.3.0
export PATH=$PATH:$EC2_HOME/bin

LOG_FILE=/mnt/volume1/Logs/backup.log
echo "Backing up volume $1"
echo "********** Starting backup for volume $1..." >> $LOG_FILE
ec2-consistent-snapshot --aws-access-key-id AWS_ACCESS_KEY_HERE --aws-secret-access-key AWS_SECRET_KEY_HERE --mysql --mysql-host localhost --mysql-username MYSQL_USERNAME_HERE --mysql-password MYSQL_PASSWORD_HERE  --freeze-filesystem /mnt/volume1 --description "Snapshot $(date +'%Y-%m-%d %H:%M:%S')" --region AWS_REGION_HERE $1
# Remove existing snapshots
/usr/bin/php -f /opt/Scripts/backup/remove_old_snapshots.php  -- args  -v $1 -n $2
# Log to file
echo "********** Ran backup: $(date)" >> $LOG_FILE
echo "Completed"
