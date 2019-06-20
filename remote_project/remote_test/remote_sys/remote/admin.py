# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.contrib import admin

from .models import Ipaddr


class IpaddrAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'status', 'remark', 'created_time')
    list_filter = ('status', 'created_time')
    search_fields = ('name', 'remark')
    fieldsets = (
        (None, {
         'fields': (
                 'name',
                 ('status', 'remark'),
                 )
         }),
    )


admin.site.register(Ipaddr, IpaddrAdmin)
