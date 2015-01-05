#!/bin/bash
#############################################################################################
# Script                : mysql_database_backup.sh
# Description           : Backup of mysql databases for a given instance using mysqldump
# Input parameters      : backup parametr file (eg: mysql_backup_3307.par)
#
# Modification history
# Date          Modified by     Version         Details
# -----------   -----------     -------         --------------------------
# 22-FEB-2012   Ramana          1.0             New script
# 14-MAR-2012   Ramana          1.1             Modified the logging into backup hist file.
#############################################################################################
#set -x
# Verify the number of input parameters.

if [ $# -ne 1 ]
then

 echo "Usage:$0 <backup parameter file>"
 echo "eg:$0 mysql_backup_3306.par"
 exit 1

fi

export DBA=/u02/mysqldata/dba
export SCR_DIR=$DBA/scripts/shell
export LOG_DIR=$DBA/log
export START_TIME=`date +"%Y%m%dT%H%M%S"`
export HOSTNAME=`hostname`
export OUT_FILE=$LOG_DIR/mysql_database_backup.out
export REMOVE_BACKUP_LIST=$LOG_DIR/mysql_backup_remove.lst
export BACKUP_HIST_FILE=$LOG_DIR/mysql_database_backup_history.log
export PWD_FILE=$SCR_DIR/.bkp
export NOTIFY_LIST=Sybase-DBA@altisource.com,bijjamve@altisource.com,MonitoringTeam@altisource.com

export PARAM_FILE=${SCR_DIR}/$1

#Check whether parameter file is available and not empty.
if [ ! -s $PARAM_FILE ]
then

  echo "Mysql backup failed on $HOSTNAME. Could not find the backup parameter file $PARAM_FILE" |mailx -s "JOB FAILURE: Mysql backup failed" $NOTIFY_LIST
  exit 1

fi

#Validate the variables from the parameter file
export MYSQL_PORT=`grep MYSQL_PORT $PARAM_FILE |grep -v ^# |awk -F"=" '{print $2}'`
export MYSQL_SOCKET=`grep MYSQL_SOCKET $PARAM_FILE |grep -v ^# |awk -F"=" '{print $2}'`
export BACKUP_FS=`grep BACKUP_FS $PARAM_FILE |grep -v ^# |awk -F"=" '{print $2}'`
export DATABASE_LIST=`grep DATABASE_LIST $PARAM_FILE |grep -v ^# |awk -F"=" '{print $2}'`
export DATABASE_BKUP_RET_DYS=`grep DATABASE_BKUP_RET_DYS $PARAM_FILE |grep -v ^# |awk -F"=" '{print $2}'`
export LOG_FILE=$LOG_DIR/mysql_database_backup_${MYSQL_PORT}_${START_TIME}.log

#Set variables for the job
export USERNAME=`grep -v ^# $PWD_FILE |awk -F: '{print $1}'`
export PASSWD=`grep -v ^# $PWD_FILE |awk -F: '{print $2}'`
export BACKUP_LOCATION=$BACKUP_FS/${MYSQL_PORT}/database
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:.

#check whether backup directory path exist.
if [ ! -d $BACKUP_LOCATION ]
then

 echo "Mysql backup failed on $HOSTNAME for port $MYSQL_PORT. Could not find the backup path $BACKUP_LOCATION." |mailx -s "JOB FAILURE: Mysql backup failed" $NOTIFY_LIST
 exit 1

fi

echo "$START_TIME: Starting MySQL database backup on $HOSTNAME for instance $MYSQL_PORT" > $LOG_FILE

#Get the list of databases for backup.

if [ $DATABASE_LIST = "ALL" ]
then

DB_LIST=`mysql --user=$USERNAME --password=$PASSWD --port=$MYSQL_PORT --socket=$MYSQL_SOCKET   --batch --skip-column-names mysql -e "select SCHEMA_NAME from information_schema.SCHEMATA WHERE SCHEMA_NAME not in ('information_schema','performance_schema')" 2>$OUT_FILE`

 if [ `grep -ic 'ERROR' $OUT_FILE` -gt 0 ]
 then

  echo "ERROR: Mysql backup failed on $HOSTNAME instance $MYSQL_PORT while checking for db list" >> $LOG_FILE
  echo "Mysql backup failed on $HOSTNAME for instance $MYSQL_PORT while checking for db list" |mailx -s "JOB FAILURE: Mysql backup failed" $NOTIFY_LIST
  exit 1

 fi

else

  DB_LIST=`echo $DATABASE_LIST |sed 's/,/\n/g'`

fi

echo "Database list for backup" >> $LOG_FILE
echo $DB_LIST >> $LOG_FILE

for DB_NAME in `echo $DB_LIST`
do

export DUMP_FILE=$BACKUP_LOCATION/mysqldump_${DB_NAME}_${MYSQL_PORT}_${START_TIME}.sql.gz

echo "Stop replication before backup" >> $LOG_FILE
mysqladmin  --user=$USERNAME --socket=$MYSQL_SOCKET --password=$PASSWD --port=$MYSQL_PORT  stop-slave >> $LOG_FILE

mysqldump --user=$USERNAME --socket=$MYSQL_SOCKET --password=$PASSWD --port=$MYSQL_PORT --databases $DB_NAME --single-transaction --max_allowed_packet=256M --flush-logs --flush-privileges --routines --master-data=2 --log-error=$OUT_FILE |gzip >$DUMP_FILE

echo "Start replication after backup" >> $LOG_FILE

mysqladmin  --user=$USERNAME --socket=$MYSQL_SOCKET --password=$PASSWD --port=$MYSQL_PORT  start-slave  >> $LOG_FILE

echo "Check slave status" >> $LOG_FILE

mysql --user=$USERNAME --password=$PASSWD --port=$MYSQL_PORT --socket=$MYSQL_SOCKET   --batch --skip-column-names mysql -e "show slave status\G" >> $LOG_FILE

echo "`date +"%Y%m%dT%H%M%S"`: Completed backup of database $DB_NAME" >> $LOG_FILE

done

if [ `grep -ic 'ERROR' $OUT_FILE` -gt 0 ]
then

  echo "CRITICAL:ERROR: Mysql backup failed on $HOSTNAME instance $MYSQL_PORT." >> $LOG_FILE
  cat $OUT_FILE >> $LOG_FILE
  export END_TIME=`date +"%Y%m%dT%H%M%S"`
  echo "$HOSTNAME       $MYSQL_PORT     mysqldump       $START_TIME     $END_TIME       FAILURE $DATABASE_LIST">> $BACKUP_HIST_FILE
  cat $LOG_FILE |mailx -s "JOB FAILURE: Mysql backup failure on $HOSTNAME instance $MYSQL_PORT" $NOTIFY_LIST
  exit 1

fi


export END_TIME=`date +"%Y%m%dT%H%M%S"`

echo "$END_TIME: Completed MySQL database backup on $HOSTNAME for instance $MYSQL_PORT" >> $LOG_FILE
echo "$HOSTNAME $MYSQL_PORT     mysqldump       $START_TIME     $END_TIME       SUCCESS $DATABASE_LIST">> $BACKUP_HIST_FILE

#Delete backups older than retention days specified.
if [ $DATABASE_BKUP_RET_DYS -gt 0 ]
then

 find $BACKUP_LOCATION -type f -mtime +${DATABASE_BKUP_RET_DYS} -print >$REMOVE_BACKUP_LIST

 if [ `wc -l $REMOVE_BACKUP_LIST |awk '{print $1}'` -gt 0 ]
 then

   echo "`date +"%Y%m%dT%H%M%S"`: Deleting following database backups older than $DATABASE_BKUP_RET_DYS days.">> $LOG_FILE
   cat $REMOVE_BACKUP_LIST >> $LOG_FILE
   cat $REMOVE_BACKUP_LIST | xargs rm 2>$OUT_FILE

   if [ $? -ne 0 ]
   then

     echo "Failure while deleting database backups older than $DATABASE_BKUP_RET_DYS in $BACKUP_LOCATION on $HOSTNAME." |mailx -s "JOB FAILURE: Database backup job failure during deletion of old backups" $NOTIFY_LIST

     exit 1

   fi

   echo "`date +"%Y%m%dT%H%M%S"`: Completed the deletion of older database backups from backup location." >> $LOG_FILE

 fi

fi

exit 0
