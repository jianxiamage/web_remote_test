#!/bin/bash

#set -e
#------------------------------
cmdStr=''
#-------------------------------
cmdEndStr="remote-Test:install depend packages.End------------------------------------"
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

write_log "INFO" "remote-Test:install depend packages.Begin--------------------------"

#install depend pkgs
yum -y install python-devel
yum -y install libffi-devel
yum -y install openssl-devel

