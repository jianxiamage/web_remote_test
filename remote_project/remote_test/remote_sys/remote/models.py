# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models


class Ipaddr(models.Model):

    STATUS_ITEMS = [
        (1, '在线'),
        (2, '离线'),
        (0, '未知'),
    ]

    name = models.CharField(max_length=128, verbose_name="IP组")
    #status = models.IntegerField(choices=STATUS_ITEMS, verbose_name="状态",null=True,blank=True)
    status = models.IntegerField(choices=STATUS_ITEMS, verbose_name="状态",default='0')
    remark = models.CharField(max_length=128, verbose_name="备注",null=True,blank=True)


    created_time = models.DateTimeField(auto_now_add=True, editable=False, verbose_name="创建时间")

    def __unicode__(self):
        return '<Ipaddr: {}>'.format(self.name)

    class Meta:
        verbose_name = verbose_name_plural = "信息"
