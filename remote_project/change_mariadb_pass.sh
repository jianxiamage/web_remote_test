#!/bin/bash

#set -e
#------------------------------
cmdStr=''
#-------------------------------
cmdEndStr="remote-Test:change the database password.End--------------------------"
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

write_log "INFO" "remote-Test:change the database password.Begin----------------"


#echo 'add skip-grant-tables to /etc/my.cnf'
echo 'Modifying the config file and restart the mariadb service...'
cp /etc/my.cnf /etc/my.cnf.bak
sed -i '/[mysqld]/askip-grant-tables' /etc/my.cnf

#echo 'restart the mariadb sevice...'

systemctl restart mariadb
sleep 1

echo 'Modifying the password...';
pwd='loongson'
mysql -uroot -e "UPDATE mysql.user SET password=PASSWORD('${pwd}') WHERE user='root'";

mysql -uroot -e "FLUSH PRIVILEGES";

sleep 2

echo '------------------------------------------'
#echo "mariadb root password is set to:${pwd}"
echo "The root password has been set to [${pwd}]."

sed -i '/skip-grant-tables/d' /etc/my.cnf
systemctl restart mariadb
