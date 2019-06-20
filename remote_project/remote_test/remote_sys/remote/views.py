# -*- coding: utf-8 -*-
from __future__ import unicode_literals
import uniout 
import os
import subprocess
import json
import socket

import sys
reload(sys)
sys.setdefaultencoding('utf8')

#from django.shortcuts import render
#from django.http import HttpResponse

from django.http import HttpResponseRedirect
from django.http import HttpResponse
from django.urls import reverse
from django.shortcuts import render
from django.shortcuts import redirect

from .models import Ipaddr
from .forms import IpaddrForm
from django.contrib.auth.decorators import login_required 

def index(request):
    ipaddrs = Ipaddr.objects.all()
    ipaddrsPre = Ipaddr.objects.all().order_by('-id')[:1]
    if request.method == 'POST':
        form = IpaddrForm(request.POST)
        if form.is_valid():
            cleaned_data = form.cleaned_data
            ipaddr = Ipaddr()
            ipaddr.name = cleaned_data['name']
            ipaddr.status = cleaned_data['status']
            ipaddr.remark = cleaned_data['remark']
            ipaddr.save()
            return HttpResponseRedirect(reverse('index'))
    else:
        form = IpaddrForm()

    context = {
        'ipaddrs': ipaddrs,
        'ipaddrsPre': ipaddrsPre,
        'form': form,
    }
    return render(request, 'index.html', context=context)

#复选框
def edit(request, ipaddr_id):
    ipaddrs = Ipaddr.objects.all()
    # 利用正向查找关于选择的tag
    ipaddrModel = Ipaddr.objects.filter(id=ipaddr_id).first()
    # 获取全部的name
    check_name = ipaddrModel.all()
    # 获取选中的id
    check_id = [int(x.id) for x in check_name]
    print check_id
    return render(request, 'index.html', {'ipaddrs': ipaddrs, 'check_id': check_id})


#通过request.REQUEST.getlist取到list形式的提交结果
def getresult(request):
    check_box_list = request.REQUEST.getlist("check_box_list")

def che(request):
    ipaddrs = Ipaddr.objects.all()
    if request.method=="POST":
        check_box_list = request.POST.getlist('IP_Info')
        if check_box_list:
            print(check_box_list)
            return HttpResponse("ok")
        else:
            print("fail")
            return HttpResponse("fail")
    else:
        a = [1,2,3,4]
        return render(request,'che.html',{'a':a})

#    form = IpaddrForm()
#
#    context = {
#        'ipaddrs': ipaddrs,
#        'form': form,
#    }
#    return render(request, 'index.html', context=context)


def check(request):
    ipaddrs = Ipaddr.objects.all()
    if request.method=="POST":
        check_box_list = request.POST.getlist('IP_Infos')
        #check_box_list = request.POST.getlist('file')
        if check_box_list:
            print(check_box_list)
            print "check_box_list[0]: ", check_box_list[0]
            return HttpResponse("ok")
        else:
            print("fail")
            return HttpResponse("fail")
    else:
        a = [1,2,3,4]
        return render(request,'check.html',{'a':a})

def my_download(request):
    #result_list = request.POST.getlist('file1', '')
    #result = str(result_list)

    ipaddrs = Ipaddr.objects.all()
    if request.method=="POST":
        check_box_list = request.POST.getlist('IP_Infos', '')
        #check_box_list = request.POST.getlist('file')
        if check_box_list:
            print(check_box_list)
            print "check_box_list[0]: ", check_box_list[0]
            return HttpResponse("ok")
        else:
            print("fail")
            return HttpResponse("fail")
    else:
        a = [1,2,3,4]
        return render(request,'check.html',{'a':a})

def operate(request):
    '''获取前台页面的用户操作选择'''
    ipaddrs = Ipaddr.objects.all()
    if request.method == "POST":


        check_box_list = request.POST.getlist('IP_Infos')
        if check_box_list:
            print('-------------------------------------------')
            print(check_box_list)
            print "check_box_list[0]: ", check_box_list[0]
            #return HttpResponse("get checkboxlist success.")
            print('-------------------------------------------')
        else:
            print("fail")
            return HttpResponse("get checkboxlist failed!")

        context = {}
        context['ipaddrs'] = check_box_list
        #return render(request,'checkStatus.html',context)


        abspath = os.path.split(os.path.realpath(__file__))[0]
        print('=======================')
        print('abspath:%s' %(abspath))
        print('--------------------')
        os.chdir(os.path.join(abspath,'scripts'))

        scriptDir = 'scripts/hostlist.txt'
        destPath = os.path.join(abspath,scriptDir)
        print('destPath:%s' %(destPath))
        #os.chdir(abspath)
        check_box_list = [line+"\n" for line in check_box_list]
        with open('hostlist.txt','a+') as flist:
           flist.truncate()
           flist.writelines(check_box_list)
        flist.close
        os.chdir(abspath)

        #return render(request,'login.html',context)

        if request.POST.has_key("checkStatus"):
           print('test checkStatus ok!')
           #return HttpResponse("checkStatus")
#           context = {}
#           context['hello'] = 'Hello World!'
#           #return render(request,'checkStatus.html',context)
#           return render(request,'login.html',context)

           print('-------------------------------------------')
           print(check_box_list)
           print "check_box_list[0]: ", check_box_list[0]
           #return HttpResponse("[checkStatus] get checkboxlist success.")

           return render(request,'login.html',context)
           print('-------------------------------------------')

        elif request.POST.has_key('ejtagDebug'):
           print('test ejtagDebug ok!')
           #return HttpResponse("ejtagDebug")

           print('-------------------------------------------')
           print(check_box_list)
           print "check_box_list[0]: ", check_box_list[0]
           #return HttpResponse("[ejtagDebug] get checkboxlist success.")
           return render(request,'ejtagDebug.html',context)
           print('-------------------------------------------')


        elif request.POST.has_key('reset'):
           print('test reset ok!')
           #return HttpResponse("reset")

           print('-------------------------------------------')
           print(check_box_list)
           print "check_box_list[0]: ", check_box_list[0]
           return HttpResponse("[reset] get checkboxlist success.")
           print('-------------------------------------------')

        else:
           print("test poweroff")
           #return HttpResponse("poweroff")

           print('-------------------------------------------')
           print(check_box_list)
           print "check_box_list[0]: ", check_box_list[0]
           return HttpResponse("[poweroff] get checkboxlist success.")
           print('-------------------------------------------')

    else:
        a = [1,2,3,4]
        return render(request,'check.html',{'a':a})

@login_required 
def login(request):
    if request.method == 'GET':
        return render(request,'login.html')
    elif request.method== 'POST':
        v = request.POST.get('project_name')
        print(v)
        if v == 'check':

            pwd=os.path.dirname(__file__)
            abspath = os.path.split(os.path.realpath(__file__))[0]
            print('--------------------')
            print('pwd:%s' %(pwd))
	    print('=======================')
            print('abspath:%s' %(abspath))
            print('--------------------')

            os.chdir(os.path.join(abspath,'scripts'))
            
            scriptDir = 'scripts/get_IPStates_Pairs.py'
            destPath = os.path.join(abspath,scriptDir)
            print('destPath:%s' %(destPath))

            child = subprocess.Popen(destPath,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True)
            stdout,stderr = child.communicate()
            #check_c = str(stdout,encoding='utf-8')

            check_c = str(stdout)

            print('check_c:%s' %(check_c))

            os.chdir(abspath)

            #with open('/data/check_log.txt','a+') as fd:
            with open('check_log.txt','a+') as fd:
               fd.write(str(check_c)) 
            print(check_c)
            os.chdir(abspath)
            return render(request, 'result_of_enforcement.html', {'project_name': '在线测试', 'Executing_processes': check_c })
        elif v == 'poweron':

            pwd=os.path.dirname(__file__)
            abspath = os.path.split(os.path.realpath(__file__))[0]
            print('--------------------')
            print('abspath:%s' %(abspath))
            print('--------------------')

            os.chdir(os.path.join(abspath,'scripts'))

            scriptDir = 'scripts/Test-Remote-poweron-bat.sh'
            destPath = os.path.join(abspath,scriptDir)
            print('destPath:%s' %(destPath))

            child = subprocess.Popen(destPath,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True)
            stdout,stderr = child.communicate()
            #poweron_c = str(stdout,encoding='utf-8')

            poweron_c = str(stdout)

            print('poweron_c:%s' %(poweron_c))

            os.chdir(abspath)

            with open('poweron_log.txt','a+') as fd:
               fd.write(str(poweron_c))
            print(poweron_c)
            os.chdir(abspath)            

            return render(request,'result_of_enforcement.html',{'project_name': '开机(重启)测试', 'Executing_processes': poweron_c })

        elif v == 'poweroff':
            pwd=os.path.dirname(__file__)
            abspath = os.path.split(os.path.realpath(__file__))[0]
            print('--------------------')
            print('abspath:%s' %(abspath))
            print('--------------------')

            os.chdir(os.path.join(abspath,'scripts'))

            scriptDir = 'scripts/Test-Remote-poweroff-bat.sh'
            destPath = os.path.join(abspath,scriptDir)
            print('destPath:%s' %(destPath))

            child = subprocess.Popen(destPath,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True)
            stdout,stderr = child.communicate()
            #poweroff_c = str(stdout,encoding='utf-8')

            poweroff_c = str(stdout)

            print('poweroff_c:%s' %(poweroff_c))

            os.chdir(abspath)

            with open('poweroff_log.txt','a+') as fd:
               fd.write(str(poweroff_c))
            print(poweroff_c)
            os.chdir(abspath)
            return render(request,'result_of_enforcement.html',{'project_name': '关机测试', 'Executing_processes': poweroff_c })

        # return render(request,'login.html')
    else:
        return redirect('/index/')



def ejtagDebug(request):
    #ipaddrs = Ipaddr.objects.all()
    if request.method=="POST":
        #ipinfo = request.POST.get('ejtagDebug')
        ipinfo = request.POST.get('ejtagIP')
        print('----------')
        print(ipinfo)
        print('----------')
        if ipinfo:
            print(ipinfo)
            print("ok")

#            pwd=os.path.dirname(__file__)
#            abspath = os.path.split(os.path.realpath(__file__))[0]
#            print('--------------------')
#            print('abspath:%s' %(abspath))
#            print('--------------------')
#            os.chdir(os.path.join(abspath,'scripts'))
#            #listexes=("mate-terminal -e 'bash -c \"ls;sh a.sh; exec bash\"'")
#            #p=subprocess.Popen(listexes,shell=True)
#            #cmdline="mate-terminal -e 'bash -c \"ls;sh b.sh; exec bash\"'"
#
#            cmdmain="mate-terminal -e 'bash -c \"sh "
#            cmdscr="Test-Remote-ejtag-param.sh"
#            cmdpara=str(ipinfo)+'pwd'
#            cmdend="; exec bash\"'"
#            cmdLine=cmdmain + cmdpara + cmdscr + cmdend
#            print(cmdLine)
#
#            listexes=(cmdLine)
#            p=subprocess.Popen(listexes,shell=True)
#
#            os.chdir(abspath)
#            return HttpResponse("转向终端执行")

            #context = {}
            #context['ipinfo'] = ipinfo
            #context['serverip'] = '10.20.42.41'
            ##context['ipinfo'] = '10.20.42.41'
            #return render(request,'ejtag.html',context)

            #Dict = {'ipinfo': ipinfo, 'serverip': '10.20.42.41'}
            context = {}
            context['ipinfo'] = ipinfo
            #server_ip = '10.20.42.41'
            server_ip = get_host_ip()
            context['serverip'] = json.dumps(server_ip)
            return render(request,'ejtag.html',context)

        else:
            print(ipinfo)
            print("fail")
            return HttpResponse("fail")

#        check_box_list = request.POST.getlist('IP_Info')
#        if check_box_list:
#            print(check_box_list)
#            return HttpResponse("ok")
#        else:
#            print("fail")
#            return HttpResponse("fail")
    else:
        a = [1,2,3,4]
        #return render(request,'che.html',{'a':a})
        return redirect('/index/')

def get_host_ip():
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(('8.8.8.8', 80))
        ip = s.getsockname()[0]
    finally:
        s.close()

    return ip
