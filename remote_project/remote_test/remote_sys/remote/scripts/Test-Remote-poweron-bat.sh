#!/bin/bash

#-----------------------------------------------------------------
username=root
passwd=loongson

DebugerIP=''
ServerIP=''
#-----------------------------------------------------------------
IP_List_File='hostlist.txt'
#tmpIP_List_File='hostlist_filter.tmp'
tmpIP_List_File="${IP_List_File}.tmp"
#-----------------------------------------------------------------
retCode=0
success=0
failed=0
debugerSuccess=0
debugerFailed=0
serverSuccess=0
serverFailed=0
DebugerStat=''
ServerStat=''
ip_pairs_stat=''
cmdLine=''
poweronTestTag=1
#-----------------------------------------------------------------
do_command()
{
        #hosts=`sed -n '/^[^#]/p' hostlist.txt`
        #hosts=`cat hostlist.txt |awk '{print $0}'`
        #cat hostlist.txt|while read host
        #echo "hosts:$hosts"
        #for host in $hosts
        #FINDFILE='hostlist.txt'
        #tmpIP_List_File='hostlist_filter.tmp'
        exec 3<$tmpIP_List_File
        while read host <&3
        do
		echo "--------------------------------------------------------"
		DebugerIP=`echo $host|awk '{print $1}'`
		ServerIP=`echo $host|awk '{print $2}'`
		echo "DebugerIP:[$DebugerIP]"
		echo "ServerIP: [$ServerIP]"
		#sshpass -p $passwd  ssh -n -o "StrictHostKeyChecking no" $username@$host "$@"
#		sh RemoteConnTest-param.sh $DebugerIP "$@" > /dev/null 2>&1
#		retCode=$?
#
#		if [ $retCode -eq 0 ]; then
#		  debugerSuccess=$(($debugerSuccess+1))
#                  echo -e "\n\033[32m$DebugerIP | success\033[0m\n"
#                  #echo "debugerSuccess:$debugerSuccess"
#		  echo $DebugerIP >> ip_debuger_active.list
#		  DebugerStat='active'
#		else
#		  debugerFailed=$(($debugerFailed+1))
#		  echo -e "\n\033[32m$DebugerIP | failed\033[0m\n"
#		  echo $DebugerIP >> ip_debuger_dead.list
#		  DebugerStat='dead'
#		fi

                sh Test-Remote-poweron-param.sh $DebugerIP $cmdLine > /dev/null 2>&1
                retCode=$?

                if [ $retCode -eq 0 ]; then
                  poweronTestTag=0
                  success=$(($success+1))
                  echo -e "\n\033[32m$DebugerIP | success\033[0m\n"
                  #echo "ServerSuccess:$debugerSuccess"
                  echo $DebugerIP >> ip_poweron_test_ok.list
                  #ServerStat='active'
                else
                  failed=$(($failed+1))
                  echo -e "\n\033[32m$DebugerIP | failed\033[0m\n"
                  echo $Debuger >> ip_poweron_test_error.list
                  #DebugerStat='dead'
                fi

#		#sh RemoteConnTest-param.sh $ServerIP "$@" > /dev/null 2>&1
#		sh check-boot.sh $ServerIP > /dev/null 2>&1
#		if [ $? -eq 0 ];then
#		  serverSuccess=$(($serverSuccess+1))
#		  #echo "serverSuccess:$serverSuccess"
#		  echo -e "\n\033[32m$ServerIP | success\033[0m\n"
#		  echo $ServerIP >> ip_server_active.list
#		  ServerStat='active'
#		else
#		  serverFailed=$(($serverfailed+1))
#		  echo -e "\n\033[32m$ServerIP | failed\033[0m\n"
#		  echo $ServerIP >> ip_server_dead.list
#		  ServerStat='dead'
#                fi
#                ip_pairs_stat="$DebugerIP:$DebugerStat | $ServerIP:$ServerStat"
#                echo $ip_pairs_stat >> ip_pairs_all_stat.txt
        done < $tmpIP_List_File

        return 0
}


rm -f ip_poweron_test_ok.list
rm -f ip_poweron_test_error.list

#Delete the space lines and comment lines
sed '/^#.*\|^[[:space:]]*$/d' $IP_List_File > $tmpIP_List_File

#local_ip=10.20.42.41

cmdLine='pwd'

#echo -e "\033[31m执行命令 : $cmdLine \033[0m"
echo '测试结果:'
do_command $cmdLine

#echo -e '\n========================================================'
echo  '========================================================'
#echo -e "\033[32mDebuger -> success: $debugerSuccess | failed: $debugerFailed \033[0m"
#echo -e "\033[32mServer  -> success: $serverSuccess | failed: $serverFailed \033[0m"
echo -e "\033[32msuccess: $success | failed: $failed \033[0m"
echo ""

if [ $poweronTestTag -eq 0 ]; then
  echo "The IP list of successful remote start is as follows:"
  cat ip_poweron_test_ok.list
fi
