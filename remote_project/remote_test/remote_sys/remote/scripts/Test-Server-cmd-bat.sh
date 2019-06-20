#!/bin/bash

#-----------------------------------------------------------------
username=root
passwd=loongson

ServerIP=''
ServerIP=''
#-----------------------------------------------------------------
IP_List_File='hostlist.txt'
#tmpIP_List_File='hostlist_filter.tmp'
tmpIP_List_File="${IP_List_File}.tmp"
#-----------------------------------------------------------------
retCode=0
success=0
failed=0
serverSuccess=0
cmdLine=''
serverCmdTag=1
ipcount=0
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
                ipcount=$(($ipcount+1))
		#DebugerIP=`echo $host|awk '{print $1}'`
		ServerIP=`echo $host|awk '{print $2}'`
		#echo "Debuger:[$ServerIP]"
		echo "ServerIP: [$ServerIP]"

                sh Test-Server-cmd-param.sh $ServerIP $cmdLine > /dev/null 2>&1
                retCode=$?

                if [ $retCode -eq 0 ]; then
                  serverCmdTag=0
                  statTag='OK'
                  success=$(($success+1))
                  echo -e "\n\033[32m$ServerIP | success\033[0m\n"
                  result="[$success] IP:[$ServerIP],cmd:[$cmdLine],result:[OK]"
                  echo $ServerIP >> ip_server_cmd_test_ok.file
                  result_all="[$ipcount] IP:[$ServerIP],cmd:[$cmdLine],result:[$statTag]"
                  echo $result_all >> ip_server_cmd_test_result.file
                else
                  statTag='OK' 
                  failed=$(($failed+1))
                  echo -e "\n\033[32m$ServerIP | failed\033[0m\n"
                  result="[$failed] IP:[$ServerIP],cmd:[$cmdLine],result:[ERROR]"
                  echo $Server >> ip_server_cmd_test_error.file
                  result_all="[$ipcount] IP:[$ServerIP],cmd:[$cmdLine],result:[$statTag]"
                  echo $result_all >> ip_server_cmd_test_result.file
                fi
                
#                if [ $retCode -eq 0 ]; then
#                  statTag='OK'
#                  result="[$ipcount] IP:[$ServerIP],cmd:[$cmdLine],result:[$statTag]"
#                  echo $ServerIP >> ip_server_cmd_test_result.file
#                else
#                  statTag='ERROR'
#                  result="IP:[$ServerIP],cmd:[$cmdLine],result:[$statTag]"
#                  echo $Server >> ip_server_cmd_test_result.file
#                fi


        done < $tmpIP_List_File

        return 0
}


rm -f ip_server_cmd_test_ok.file
rm -f ip_server_cmd_test_error.file
rm -f ip_server_cmd_test_result.file
#Delete the space lines and comment lines
sed '/^#.*\|^[[:space:]]*$/d' $IP_List_File > $tmpIP_List_File

#local_ip=10.20.42.41

cmdLine='pwd'

echo -e "\033[31m执行命令 : $cmdLine \033[0m"
do_command $cmdLine

#echo -e '\n========================================================'
echo  '========================================================'
#echo -e "\033[32mServer -> success: $debugerSuccess | failed: $debugerFailed \033[0m"
#echo -e "\033[32mServer  -> success: $serverSuccess | failed: $serverFailed \033[0m"
echo -e "\033[32msuccess: $success | failed: $failed \033[0m"
echo ""
if [ $serverCmdTag -eq 0 ]; then
  echo "The IP list of successful remote cmd is as follows:"
  cat ip_server_cmd_test_ok.file
fi

