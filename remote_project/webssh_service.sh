#!/bin/bash 

#-----------------------------------------
service_name='webssh_service'
process_name='wssh'
#-----------------------------------------
#pushd .

export WORKON_HOME=/home/work/env-wrapper

cd  /home/download-dir/remote_project
#-----------------------------------------
case $1 in
start) 
echo "启动服务:$service_name..."
nohup sh runserver_webssh.sh webssh-master 8888  > webssh.out  2>&1 &
echo "服务$service_name已启动"
;; 

stop) 
echo "关闭服务:$service_name"

pidlist=`ps -ef |grep $process_name |grep -v "grep"|awk '{print $2}'` 
if [ ! -n "$pidlist" ]; then
  echo "服务未开启"
else
  kill -9 $pidlist
fi
#删除日志文件，如果你不先删除可以不要下面一行 
#rm $service_name/logs/* -rf
#删除remote_sys的临时目录 
#rm $service_name/work/* -rf
;; 

restart) 
echo "关闭$service_name"
 
pidlist=`ps -ef |grep $process_name |grep -v "grep"|awk '{print $2}'` 
if [ ! -n "$pidlist" ]; then
  echo "服务未开启"
else
  kill -9 $pidlist
fi
#删除日志文件，如果你不先删除可以不要下面一行 
#rm $service_name/logs/* -rf 
#删除remote_sys的临时目录 
#rm $service_name/work/* -rf 
sleep 3 
echo "启动服务:$service_name..."
nohup sh runserver_webssh.sh webssh-master 8888  > webssh.out  2>&1 &
echo "服务$service_name已启动"
#看启动日志 
#tail -f $service_name/logs/catalina.out 
;; 
logs) 
cd /home/download-dir/remote_project
tail -f remote_sys.out 
;; 
esac 

#popd

