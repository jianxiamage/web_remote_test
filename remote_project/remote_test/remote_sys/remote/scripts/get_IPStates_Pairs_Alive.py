#!/bin/python
#_*_coding:utf-8_*_

#coding=utf-8
import sys
import traceback
import time
import datetime

 
src_path = 'ip_pairs_all_stat.txt'
dest_path= 'ip_pairs_alive.list'
 
def get_data(inputParam):

    line=inputParam.strip('\n')
    str_newline = ''
    line = line.split("|")#按照竖线分割每一行里面的数据
    str_ip_pairs=line[0]+' ' + line[1]
    #print("str_ip_pairs:%s\n" %(str_ip_pairs))
    
    lineLeft = line[0].split(":")#按照冒号分割数据
    str_left=lineLeft[0]+' ' + lineLeft[1]
    
    lineRight = line[1].split(":")#按照冒号分割数据
    str_right=lineRight[0]+' ' + lineRight[1]
    
    #leftStat=lineLeft[1].replace('\n', '')#not effective
    leftStat=lineLeft[1].strip()
    rightStat=lineRight[1].strip()
    
    leftItem=lineLeft[0].strip()
    rightItem=lineRight[0].strip()

    if leftStat=='alive' and rightStat=='alive':
       print('==========left and right alive===================')
       str_newline = leftItem + ' '+ rightItem
       print(str_newline)

    return str_newline

starttime = datetime.datetime.now()
 
try:
    with open(src_path, 'r') as f:
        #a = f.read()
        #ip_list = [i for i in a.splitlines() if i != '']
        ip_list = [line.strip() for line in f.readlines()]
        f.close()

    writeFile=open(dest_path, 'w')

    print '需要查询的IP组数是：%d\n' % len(ip_list)
    k = 1
    j = 1
    for ip in ip_list:
        #print '正在查询第 %d 组IP:%s' % (k, ip)
        writeLine = get_data(ip)
        #print '正在写入第 %d 组IP的查询结果!' % k
        if len(writeLine)!=0:
          print '正在写入第 %d 组IP' % (k)
          j += 1
          writeFile.write(writeLine+'\n')
          print '第 %d 组IP的查询结果写入完毕!\n' % j
        k += 1
    print '查询完毕!\n'
except Exception as e:
    traceback.print_exc()
    sys.exit()

endtime = datetime.datetime.now()
result_sec=(endtime - starttime).seconds

print("程序开始时间:%s\n" % (starttime))
print("程序结束时间:%s\n" % (endtime))

print("程序运行时间:%s秒\n" % (result_sec))

