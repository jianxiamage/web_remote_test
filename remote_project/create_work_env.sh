#!/bin/bash

#set -e
#------------------------------
cmdStr=''
#-------------------------------
cmdEndStr="remote-Test:create work environment.End------------------------------------"
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

write_log "INFO" "remote-Test:create work environment.Begin--------------------------"

if [ ! -d "/root/work" ]; then
  echo "/root/work Not Exist, build it"
  mkdir /root/work
else
  echo "/root/work already exists"
fi

pushd .

cd /root/work/

rm -rf *

#install pip
yum -y install python-pip

#install virtualenv
pip install virtualenv

mkdir env-virtual
cd env-virtual

virtualenv env-remote

virtualenv env-webssh

popd
