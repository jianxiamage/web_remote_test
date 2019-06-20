#!/bin/bash　　

#set -e
#------------------------------
cmdStr=''
#-------------------------------
cmdEndStr="remote-Test:create database.End------------------------------------"
#----------------------------------------------------------------------------------
source ./shell-log.sh
logFile=$logFile
#echo $logFile
write_log=$write_log
#----------------------------------------------------------------------------------
source ./exceptionTrap.sh
exit_end=$exit_end
exit_err=$exit_err
exit_int=$exit_int
#----------------------------------------------------------------------------------
trap 'exit_end "${cmdEndStr}"' EXIT
trap 'exit_err $LINENO $?'     ERR
trap 'exit_int'                INT
#----------------------------------------------------------------------------------

write_log "INFO" "remote-Test:create database.Begin---------------------------"


HOSTNAME="127.0.0.1"
PORT="3306"
USERNAME="root"
PASSWORD="loongson"

DBNAME="remotetest"
TABLENAME="test_table_test"

#也可以写 HOSTNAME="localhost"，端口号 PORT可以不设定

 #创建数据库
create_db_sql="drop database if exists remotetest"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} -e "${create_db_sql}"

create_db_sql="create database remotetest default charset=utf8"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} -e "${create_db_sql}"
