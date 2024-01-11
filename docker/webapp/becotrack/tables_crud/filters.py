from dataclasses import fields
from pyexpat import model
import django_filters

from base.models import *

class OrderFilter(django_filters.FilterSet):
    class Meta:
        model = VwReadtags
        fields = ['tag_name']