#!/bin/bash

#set -e
#------------------------------
cmdStr=''
#-------------------------------
cmdEndStr="remote-Test:deploy work environment for remote_sys project.End--------------------------"
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

write_log "INFO" "remote-Test:deploy work environment for remote_sys project.Begin----------------"


cd /root/work/
#cd project_remote
source /root/work/env-virtual/env-remote/bin/activate

cd /home/download-dir/remote_project/remote_test

#install mariadb driver
pip install MySQL-python

#install packages required for the current project
pip install -r packages.txt

#启动web服务
cd /home/download-dir/remote_project/remote_test/remote_sys
python manage.py runserver 0.0.0.0:8000 --insecure
