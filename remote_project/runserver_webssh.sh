#! /bin/bash

#set -e
#------------------------------
cmdStr=''
#-------------------------------
cmdEndStr="remote-Test:start runserver for project:webssh.End------------------------------------"
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

write_log "INFO" "remote-Test:start runserver for project:webssh.Begin--------------------------"


PROJECT_PATH="/home/download-dir/remote_project/webssh-project-pkg/"
env_project="env-webssh"
is_work=1
# 判断是否有两个参数： 项目名：启动端口
if [ $# != "2" ]
then
    echo "usage: $0 <project_name> <runport>"
    is_work=0
fi

# 定义一个函数
run_temp_server(){
    project_name=$1 # 传到函数的第一个参数 $0依然是文件名
    runport=$2 # 第二个参数 端口
    project_dir="$PROJECT_PATH$project_name/" # 拼接字符串
    # 检查项目文件夹是否存在
    if [ ! -d $project_dir ]
    then
        echo "no such file or directory: $project_dir"
    # 存在则执行下面命令
    else
        # 像在终端一样使用这些shell 命令
        #deactiavte
        active_virtual_env
        echo ---------------------------------
        echo 'change to virtualenv:env-webssh'
        echo ---------------------------------

        cd $project_dir
        workon $env_project
        wssh --address='0.0.0.0' --port=$runport
    fi
}

active_virtual_env(){
  export WORKON_HOME=/home/work/env-wrapper

  echo ---------------------------------
  echo 'active the virtualenvwrapper'
  echo ---------------------------------
  source /usr/bin/virtualenvwrapper.sh

}

if [ $is_work -eq "1" ]
then
    # 执行函数 并且传入参数
    run_temp_server  $1 $2
fi

