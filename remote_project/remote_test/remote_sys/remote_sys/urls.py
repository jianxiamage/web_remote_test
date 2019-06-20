"""remote_sys URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.11/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.conf.urls import url, include
    2. Add a URL to urlpatterns:  url(r'^blog/', include('blog.urls'))
"""

# coding:utf-8

from django.conf.urls import url
from django.contrib import admin

from remote.views import index
from remote.views import che 
from remote.views import check 
from remote.views import my_download
from remote.views import operate
from remote.views import login
from remote.views import ejtagDebug

urlpatterns = [

    url(r'^login', login, name="login"),
    url(r'^operate/$', operate ,name="operate"),
    url(r'^ejtagDebug/$', ejtagDebug ,name="ejtagDebug"),
    url(r'^DownLoad/$', my_download ,name="my_download"),
    url(r'^che/$', che ,name="che"),
    url(r'^check/$', che ,name="check"),
    url(r'^$', index, name='index'),
    url(r'^admin/', admin.site.urls),
]
