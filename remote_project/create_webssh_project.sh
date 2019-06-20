#!/bin/bash

#set -e
#------------------------------
cmdStr=''
#-------------------------------
cmdEndStr="remote-Test:deploy work environment for webssh.End------------------------------------"
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

write_log "INFO" "remote-Test:deploy work environment for webssh.Begin--------------------------"

#install depend pkgs
#yum -y install python-devel
#yum -y install libffi-devel
#yum -y install openssl-devel

source /root/work/env-virtual/env-webssh/bin/activate

cd /home/download-dir/remote_project/webssh-project-pkg/webssh-master

python setup.py install

#启动web服务
wssh --address='0.0.0.0' --port=8888
