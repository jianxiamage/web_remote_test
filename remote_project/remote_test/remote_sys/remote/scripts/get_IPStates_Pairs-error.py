#!/bin/python
#_*_coding:utf-8_*_

import os
import re
import time
import datetime
import random
import threading
import subprocess
import pexpect


#root = os.getcwd()
#root =  os.path.split(os.path.realpath(__file__))[0]
#print('rootPath:%s' %(root))
#filename = 'hostlist.txt'
#destPath = os.path.join(root,filename)
#print('destPath:%s' %(destPath))

#hostFile = open(destPath)
hostFile = open('hostlist.txt')
hostList = [line.strip() for line in hostFile.readlines()]
hostFile.close()
#print hostList

ip_pairs_all_file=open('ip_pairs_all_stat.txt','w')  #新建一个储存有效IP的文档
lock=threading.Lock()  #建立一个锁
ServerStat=''

def test(i):
    try:
        #lock.acquire()     #获得锁
        #print(hostList[i],'is OK')
        #print(hostList[i])
        line = hostList[i].split(" ")#按照空格键分割每一行里面的数据
        str_ip_pairs=line[0]+' | ' + line[1]
        #print("%s\n" %(str_ip_pairs))
        DebugerIP=str(line[0])
        ServerIP=str(line[1])
        #print 'DebugerIP:%s      ServerIP:%s\n' %DebugerIP %ServerIP
        #print(DebugerIP)
        #print(ServerIP)
#核心部分:Begin-----------------------------------------------------------------------
        #cmd_DebugerIP='ping'+ ' ' + DebugerIP + ' -c 1 -s 1 -W 1 | grep "100% packet loss"|wc -l'
        #ret=subprocess.call(cmd_DebugerIP,shell=True,stdout=open('/dev/null','w'),stderr=subprocess.STDOUT)
        ping=pexpect.spawn("ping -c1 %s" % (DebugerIP))
        ret=ping.expect([pexpect.TIMEOUT,"1 packets transmitted, 1 received, 0% packet loss"],2)
        if ret==1:
           #print '%s is alive!\n' %DebugerIP
           DebugerStat=DebugerIP + ':alive'            
        else:
           #print '%s is down...\n'%DebugerIP
           DebugerStat=DebugerIP + ':down'

        #cmd_ServerIP='ping' + ' ' + ServerIP + ' -c 1 -s 1 -W 1 | grep "100% packet loss"|wc -l'
        #print(cmd_ServerIP)
        #ret=subprocess.call(cmd_ServerIP,shell=True,stdout=open('/dev/null','w'),stderr=subprocess.STDOUT)
        ping=pexpect.spawn("ping -c1 %s" % (ServerIP))
        ret=ping.expect([pexpect.TIMEOUT,"1 packets transmitted, 1 received, 0% packet loss"],2)

        if ret==1:
           #print '%s is alive!\n' %ServerIP
           ServerStat=ServerIP + ':alive'
        else:
           print '%s is down...\n'%ServerIP
           #ServerStat=ServerIP + ':down'

        ip_pairs_stat = DebugerStat + ' | ' + ServerStat
        print(ip_pairs_stat)


#核心部分:End-----------------------------------------------------------------------

        #ip_pairs_all_file.write('%s\n' %str(hostList[i]))#写入成对IP状态到文件
        ip_pairs_all_file.write('%s\n' %str(ip_pairs_stat))#写入成对IP状态到文件
        #lock.release()     #释放锁
    except Exception as e:
        #lock.acquire()
        print(hostList[i],e)
        #lock.release()

starttime = datetime.datetime.now()

#单线程验证
'''for i in range(len(hostList)):
    test(i)
'''
#多线程验证    
threads=[]
for i in range(len(hostList)):
    thread=threading.Thread(target=test,args=[i])
    threads.append(thread)
    thread.start()
#阻塞主进程，等待所有子线程结束
for thread in threads:
    thread.join()
    
ip_pairs_all_file.close()  #关闭文件

print('\n')

endtime = datetime.datetime.now()
result_sec=(endtime - starttime).seconds

print("程序开始时间:%s\n" % (starttime))
print("程序结束时间:%s\n" % (endtime))

print("程序运行时间:%s秒\n" % (result_sec))
