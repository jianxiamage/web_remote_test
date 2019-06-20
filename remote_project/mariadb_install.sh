#!/bin/sh

#set -e
#------------------------------
cmdStr=''
#-------------------------------
cmdEndStr="remote-Test:mariadb install.End------------------------------------"
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

write_log "INFO" "remote-Test:mariadb install.Begin---------------------------------"

#安装数据库mariadb
yum -y install mariadb-server mariadb

#启动MariaDB
systemctl start mariadb

#设置开机启动
systemctl enable mariadb

#相关命令：
#systemctl stop mariadb  #停止MariaDB
#systemctl restart mariadb  #重启MariaDB

#修改默认数据库密码(下列命令重装时不可用)
#mysqladmin -u root password 'loongson'
sh change_mariadb_pass.sh

#安装数据库驱动依赖
yum -y install gcc mariadb-devel

