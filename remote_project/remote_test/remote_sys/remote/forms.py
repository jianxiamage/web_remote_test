# coding:utf-8
from __future__ import unicode_literals

from django import forms

from .models import Ipaddr


class IpaddrForm(forms.ModelForm):
    def clean_qq(self):
        cleaned_data = self.cleaned_data['qq']
        if not cleaned_data.isdigit():
            raise forms.ValidationError('必须是数字！')

        return int(cleaned_data)

    class Meta:
        model = Ipaddr
        fields = (
            'name', 'status', 'remark'
        )
