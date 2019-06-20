#!/bin/bash

#set -e

if [ ! ${UID} -eq 0 ]; then
        echo "You should run as root!"
        exit 1
fi

#----------------------------------------------------------------------------------
pushd .
echo 'change dir to /home...'
cd /home/
rm -rf download-dir
mkdir download-dir
cd download-dir
echo "Begin to download the remote project..."
rm -f remote_project.tar.gz

#----------------------------------------------------------------------------------
remote_project_Name_file=remote_project_name.log

retCode=0
echo "Check for the remote_project_name.log before remotely downloading...."
wget --spider -q -o /dev/null --tries=1 -T 5 ftp://10.2.5.21/tmp/Remote_Project/$remote_project_Name_file
retCode=$?

if [ ${retCode} -ne 0 ]; then
   echo 'Error:There is no resource(remote_project_name.log) on the remote web server,please check it!'
   exit ${retCode}
fi

echo -e "\nBegin to download remote_project_name.log....\n"

wget -c ftp://10.2.5.21/tmp/Remote_Project/$remote_project_Name_file
retCode=$?

if [ ${retCode} -ne 0 ]; then
   echo 'Error:Download remote_project_name.log from remote web failed,Maybe your network is disconnected,please check it!'
   exit ${retCode}
fi

#wget ftp://10.2.5.21/tmp/Remote_Project/$remote_project_Name_file
remote_project_Name=`cat $remote_project_Name_file`

#----------------------------------------------------------------------------------

remote_project_DownAddr="ftp://10.2.5.21/tmp/Remote_Project/$remote_project_Name"

wget --spider -q -o /dev/null --tries=1 -T 5 $remote_project_DownAddr
retCode=$?
if [ ${retCode} -ne 0 ]; then
   echo 'Error:There is no resource ${remote_project_Name} on the remote web server,please check it!'
   exit ${retCode}
fi

wget -c --progress=bar:force $remote_project_DownAddr
retCode=$?

if [ ${retCode} -ne 0 ]; then
   echo 'Error:Download ${remote_project_Name} from remote web failed,Maybe your network is disconnected,please check it!'
   exit ${retCode}
fi

echo "Download the remote_project file End."

rm -rf $remote_project_Name_file

echo $remote_project_Name > projectName.txt

#change the remote project file Name to:remote_project
mv $remote_project_Name remote_project.tar.gz

tar zxf remote_project.tar.gz 

popd
