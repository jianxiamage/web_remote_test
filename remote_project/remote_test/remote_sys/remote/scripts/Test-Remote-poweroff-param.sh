#/bin/bash

#----------------------------------------------------------------
cmdStr=''
retCode=0
#----------------------------------------------------------------
cmdEndStr="Remote Test:Shutdown the remote node End-------------------------"
DebugerIP=''
DebugerUser='root'
DebugerPass='loongson'
cmdLine=''
shLine=''
retCode=0
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
trap 'exit_int $LINENO'        INT
#----------------------------------------------------------------------------------

write_log "INFO" "Remote Test:Shutdown the remote node Begin-----------------------"
echo "Remote Test:start the remote node..."

if [ $# -ne 2 ];then
    echo "Parameter error,usage:Test-Remote-poweroff-param.sh DebugerIP cmdLine"
    exit 1
fi


#Exit the script if an error happens
#set -e

#====================================================================================================
#sshpass -p 'loongson' ssh root@10.20.42.220 'pwd'

#sshpass -p 'loongson' ssh  -o StrictHostKeyChecking=no root@$10.20.42.220 $dest_path/$script_name

#sshpass -p 'loongson' ssh  -o StrictHostKeyChecking=no root@$10.20.42.220 /tmp/3B_Ctrl/3B_on.sh
#sshpass -p 'loongson' ssh  -o StrictHostKeyChecking=no root@$10.20.42.220 /tmp/3B_Ctrl/3B_off.sh

#====================================================================================================

echo "Remote connection Test..."

DebugerIP=$1
cmdLine=$2
#sh RemoteConnTest-param.sh $DebugerIP $cmdLine

trap - ERR

sh RemoteConnTest-param.sh $DebugerIP $cmdLine
retCode=$?

trap 'exit_err $LINENO $?'     ERR

if [ $retCode -eq 0 ]; then
  cmdStr="=====connect to $DebugerIP success."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
  echo ""
else
  cmdStr="Error:connect to $DebugerIP failed!Please check it!"
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit 1
fi

#====================================================================================================

curtimeBegin=`echo $(date +"%F %T")`
echo "===================current time is:$curtimeBegin"
echo ""

shLine='/tmp/3B_Ctrl/3B_off.sh'

#sshpass -p 'loongson' ssh  root@$10.20.42.220 /tmp/3B_Ctrl/3B_off.sh
#sshpass -p $DebugerPass ssh $DebugerUser@$DebugerIP $cmdLine

trap - ERR

sshpass -p $DebugerPass ssh $DebugerUser@$DebugerIP $shLine
retCode=$?
echo "=====remote execute:power off.retCode:$retCode"

trap 'exit_err $LINENO $?'     ERR

if [ $retCode -eq 0 ]; then
  cmdStr="=====remote cmd executed success."
  echo $cmdStr
  write_log "INFO" "${cmdStr}"
  echo ""
  curtimeEnd=`echo $(date +"%F %T")`
  echo "===================current time is:$curtimeEnd"
else
  cmdStr="Error:remote cmd executed failed!Please check it!"
  echo $cmdStr
  write_log "ERROR" "${cmdStr}"
  exit 1
fi

cmdStr="Remote cmd [Power-off] executed success."
echo $cmdStr
write_log "INFO" "${cmdStr}"

