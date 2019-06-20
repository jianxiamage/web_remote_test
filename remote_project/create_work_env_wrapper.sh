#!/bin/bash　　

#set -e
#------------------------------
cmdStr=''
#-------------------------------
cmdEndStr="remote-Test:create work env by virtualenvwrapper.End------------------------------------"
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

write_log "INFO" "remote-Test:create work env by virtualenvwrapper.Begin---------------------------"


if [ ! -d "/home/work" ]; then
  echo "/home/work Not Exist, build it"
  mkdir /home/work
else
  echo "/home/work already exists"
fi

pushd .

cd /home/work/

rm -rf *

#install pip
yum -y install python-pip

echo ---------------------------------
echo 'installing virtualenvwrapper...'
echo ---------------------------------
pip install virtualenvwrapper

export WORKON_HOME=/home/work/env-wrapper

echo ---------------------------------
echo 'active the virtualenvwrapper'
echo ---------------------------------
source /usr/bin/virtualenvwrapper.sh

echo -------------------------------------------------
echo 'creating the virtual environment:env-remote...'
echo -------------------------------------------------
mkvirtualenv env-remote

echo -------------------------------------------------
echo 'creating the virtual environment:env-webssh...'
echo -------------------------------------------------
mkvirtualenv env-webssh

echo ---------------------------------
echo 'show virtual environment:'
echo ---------------------------------
lsvirtualenv -b

popd
