#!/bin/bash
#############################################################################################
# Script                : mysql_binlog_backup.sh
# Description           : Binary log backup of mysql instance
# Input parameters      : backup parametr file (eg: mysql_backup_3307.par)
#
# Modification history
# Date          Modified by     Version         Details
# -----------   -----------     -------         --------------------------
# 12-FEB-2012   Ramana          1.0             New script
# 17-FEB-2012   Ramana          1.1             Compress files if PURGE_BIN_LOGS is YES.
# 22-FEB-2012   Ramana          1.2             Added additional comments to log file.
#############################################################################################
#set -x
# Verify the number of input parameters.

if [ $# -ne 1 ]
then

 echo "Usage:$0 <backup parameter file>"
 echo "eg:$0 mysql_backup_3307.par"
 exit 1

fi

export DBA=/u02/mysqldata/dba
export SCR_DIR=$DBA/scripts/shell
export LOG_DIR=$DBA/log
export START_TIME=`date +"%Y%m%dT%H%M%S"`
export HOSTNAME=`hostname`
export OUT_FILE=$LOG_DIR/mysql_binlog_backup.out
export REMOVE_BINLOG_LIST=$LOG_DIR/mysql_binlog_remove.lst
export BACKUP_HIST_FILE=$LOG_DIR/mysql_binlog_backup_history.log
export PWD_FILE=$SCR_DIR/.bkp
export NOTIFY_LIST=Sybase-DBA@altisource.com

export PARAM_FILE=${SCR_DIR}/$1

#Check whether parameter file is available and not empty.
if [ ! -s $PARAM_FILE ]
then

  echo "Bin log backup failed on $HOSTNAME. Could not find the backup parameter file $PARAM_FILE" |mailx -s "JOB FAILURE: Bin log backup failed" $NOTIFY_LIST
  exit 1

fi

#Validate the variables from the parameter file
export MYSQL_PORT=`grep MYSQL_PORT $PARAM_FILE |grep -v ^# |awk -F"=" '{print $2}'`
export BIN_LOG_PATH=`grep BIN_LOG_PATH $PARAM_FILE |grep -v ^# |awk -F"=" '{print $2}'`
export MYSQL_SOCKET=`grep MYSQL_SOCKET $PARAM_FILE |grep -v ^# |awk -F"=" '{print $2}'`
export BACKUP_FS=`grep BACKUP_FS $PARAM_FILE |grep -v ^# |awk -F"=" '{print $2}'`
export PURGE_BIN_LOGS=`grep PURGE_BIN_LOGS $PARAM_FILE |grep -v ^# |awk -F"=" '{print $2}'`
export BIN_LOG_BKUP_RET_DYS=`grep BIN_LOG_BKUP_RET_DYS $PARAM_FILE |grep -v ^# |awk -F"=" '{print $2}'`
export LOG_FILE=$LOG_DIR/mysql_binlog_backup_${MYSQL_PORT}_${START_TIME}.log

#Set variables for the job
export BIN_LOG_LIST=$LOG_DIR/mysql_bin_log_list
export USERNAME=`grep -v ^# $PWD_FILE |awk -F: '{print $1}'`
export PASSWD=`grep -v ^# $PWD_FILE |awk -F: '{print $2}'`
export BACKUP_LOCATION=$BACKUP_FS/${MYSQL_PORT}/binlog
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:.

#check whether backup directory path exist.
if [ ! -d $BACKUP_LOCATION ]
then

 echo "Bin log backup failed on $HOSTNAME for port $MYSQL_PORT. Could not find the backup path $BACKUP_LOCATION." |mailx -s "JOB FAILURE: Bin log backup failed" $NOTIFY_LIST
 exit 1

fi

echo "$START_TIME: Starting MySQL bin log backup on $HOSTNAME for instance $MYSQL_PORT" > $LOG_FILE

#flush logs
mysql --user=$USERNAME --password=$PASSWD --port=$MYSQL_PORT --socket=$MYSQL_SOCKET --batch --skip-column-names mysql -e "flush logs" 2>$OUT_FILE
if [ `grep -c 'ERROR' $OUT_FILE` -gt 0 ]
then

  echo "Bin log backup failed on $HOSTNAME for port $MYSQL_PORT while executing flush logs." |mailx -s "JOB FAILURE: Bin log backup failed" $NOTIFY_LIST
  exit 1

fi

echo "`date +"%Y%m%dT%H%M%S"`: Completed flush logs." >> $LOG_FILE

#find the current master log
MASTER_BIN_LOG=`mysql --user=$USERNAME --password=$PASSWD --port=$MYSQL_PORT --socket=$MYSQL_SOCKET --batch --skip-column-names mysql -e "show master status" 2>$OUT_FILE |cut -f1`

if [ `grep -c 'ERROR' $OUT_FILE` -gt 0 ] || [ "$MASTER_BIN_LOG" = "" ]
then

  echo "Bin log backup failed on $HOSTNAME for instance $MYSQL_PORT while checking for current master log." |mailx -s "JOB FAILURE: Bin log backup failed" $NOTIFY_LIST
  echo "ERROR: Bin log backup failed on $HOSTNAME for instance $MYSQL_PORT while checking for current master log." >> $LOG_FILE
  exit 1

fi

find $BIN_LOG_PATH ! -newer ${BIN_LOG_PATH}/${MASTER_BIN_LOG} -print |grep -v ${BIN_LOG_PATH}/${MASTER_BIN_LOG} | grep -v index |grep -vx $BIN_LOG_PATH > $BIN_LOG_LIST

echo "`date +"%Y%m%dT%H%M%S"`: List of binary logs for backup." >> $LOG_FILE
cat $BIN_LOG_LIST >> $LOG_FILE

# Copy files

COPY_STATUS=0
for FILE in `cat $BIN_LOG_LIST`
do
 rsync -a $FILE $BACKUP_LOCATION >& /dev/null
 if [ $? -ne 0 ]
 then

  COPY_STATUS=1
  break

 fi

done


if [ $COPY_STATUS -eq 1 ]
then

  echo "ERROR: Bin log backup failed on $HOSTNAME instance $MYSQL_PORT ." >> $LOG_FILE
  echo "$HOSTNAME       $MYSQL_PORT     BINLOG BACKUP   $START_TIME     FAILURE ">> $BACKUP_HIST_FILE
  echo "Bin log backup failed on $HOSTNAME for instance $MYSQL_PORT  while copying the files" |mailx -s "JOB FAILURE: Bin log backup failed" $NOTIFY_LIST
  exit 1

fi

echo "`date +"%Y%m%dT%H%M%S"`: Copied the binary logs to $BACKUP_LOCATION ." >> $LOG_FILE

#Purge the logs if required.

if [ $PURGE_BIN_LOGS = "YES" ]
then

  #purge the logs upto and excluding master log.
  mysql --user=$USERNAME --password=$PASSWD --port=$MYSQL_PORT --socket=$MYSQL_SOCKET  --batch --skip-column-names mysql -e "PURGE BINARY LOGS TO '$MASTER_BIN_LOG'" 2>$OUT_FILE

 if [ `grep -c 'ERROR' $OUT_FILE` -gt 0 ]
 then

  echo "Bin log backup failed on $HOSTNAME for port $MYSQL_PORT while purging the binary logs." |mailx -s "JOB FAILURE: Bin log backup failed" $NOTIFY_LIST
  exit 1

 fi

 echo "`date +"%Y%m%dT%H%M%S"`: Purged the binary logs until master log $MASTER_BIN_LOG ." >> $LOG_FILE

# compress the binlogs if PURGE_BIN_LOGS=YES.
  BIN_LOG_PREFIX=`echo $MASTER_BIN_LOG | awk -F"." '{print $1}'`
  ls ${BACKUP_LOCATION}/${BIN_LOG_PREFIX}* |grep -v gz$ |xargs gzip 2>$OUT_FILE

 if [ $? -ne 0 ]
 then

  echo "Bin log backup failed on $HOSTNAME for port $MYSQL_PORT while compressing the binary logs." |mailx -s "JOB FAILURE: Bin log backup failed" $NOTIFY_LIST
  exit 1

 fi

 echo "`date +"%Y%m%dT%H%M%S"`: Compressed the binary logs at $BACKUP_LOCATION ." >> $LOG_FILE

fi

export END_TIME=`date +"%Y%m%dT%H%M%S"`

echo "$END_TIME: Completed MySQL bin log backup on $HOSTNAME for instance $MYSQL_PORT ." >> $LOG_FILE
echo "$HOSTNAME $MYSQL_PORT     BINLOG BACKUP   $START_TIME     $END_TIME       SUCCESS PURGE_BIN_LOGS=$PURGE_BIN_LOGS">> $BACKUP_HIST_FILE

#Delete backup copies of bin logs older than BIN_LOG_BKUP_RET_DYS specified in the parameter file.

if [ $BIN_LOG_BKUP_RET_DYS -gt 0 ]
then

 find $BACKUP_LOCATION -type f -mtime +${BIN_LOG_BKUP_RET_DYS} -print >$REMOVE_BINLOG_LIST

 if [ `wc -l $REMOVE_BINLOG_LIST |awk '{print $1}'` -gt 0 ]
 then

   echo "`date +"%Y%m%dT%H%M%S"`: Deleting following backup copies of bin logs older than $BIN_LOG_BKUP_RET_DYS days.">> $LOG_FILE
   cat $REMOVE_BINLOG_LIST >> $LOG_FILE
   cat $REMOVE_BINLOG_LIST | xargs rm 2>OUT_FILE

   if [ $? -ne 0 ]
   then

     echo "Failure while deleting backup copies of bin logs older than $BIN_LOG_BKUP_RET_DYS in $BACKUP_LOCATION on $HOSTNAME." |mailx -s "JOB FAILURE: Bin log backup job failure during deletion of old backup copies" $NOTIFY_LIST

     exit 1

   fi

   echo "`date +"%Y%m%dT%H%M%S"`: Completed the deletion of older binlogs from backup location." >> $LOG_FILE

 fi

fi

exit 0
