#!/bin/bash

#set -e
#------------------------------
cmdStr=''
#-------------------------------
cmdEndStr="remote-Test:deploy work environment for remote_sys project(virtualwrapper).End--------------------------"
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

write_log "INFO" "remote-Test:deploy work environment for remote_sys project(virtualwrapper).Begin----------------"

export WORKON_HOME=/home/work/env-wrapper

echo ---------------------------------
echo 'active the virtualenvwrapper'
echo ---------------------------------
source /usr/bin/virtualenvwrapper.sh

echo ---------------------------------
echo 'change to virtualenv:env-remote'
echo ---------------------------------
workon env-remote

cd /home/download-dir/remote_project/remote_test

#install mariadb driver
echo 'installing mariadb driver...'
pip install MySQL-python

#install packages required for the current project
pip install -r packages.txt

#model migrate
cd /home/download-dir/remote_project/remote_test/remote_sys
python manage.py makemigrations
python manage.py migrate

#create superuser
#python manage.py createsuperuser

echo "from django.contrib.auth.models import User; User.objects.filter(email='admin@example.com').delete(); User.objects.create_superuser('admin', 'admin@example.com', 'loongson')" | python manage.py shell

#启动web服务
#cd /home/download-dir/remote_project/remote_test/remote_sys
#python manage.py runserver 0.0.0.0:8000 --insecure
