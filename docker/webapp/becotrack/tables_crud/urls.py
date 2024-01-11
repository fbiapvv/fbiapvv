"""becotrack URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from . import views


urlpatterns = [
    path('BeaconReaders-list', views.BeaconReadersList, name='BeaconReaders-list'),
    path('BeaconReaders-create', views.BeaconReadersCreate, name='BeaconReaders-create'),
    path('BeaconReaders-update/<int:id>', views.BeaconReadersUpdate, name='BeaconReaders-update'),
    path('BeaconReaders-delete/<int:id>', views.BeaconReadersDelete, name='BeaconReaders-delete'),
    path('BeaconTags-list', views.BeaconTagsList, name='BeaconTags-list'),
    path('BeaconTags-create', views.BeaconTagsCreate, name='BeaconTags-create'),
    path('BeaconTags-update/<int:id>', views.BeaconTagsUpdate, name='BeaconTags-update'),
    path('BeaconTags-delete/<int:id>', views.BeaconTagsDelete, name='BeaconTags-delete'),
    path('BeaconTags-delete/all', views.BeaconTagsDeleteAll, name='BeaconTags-delete-all'),
    path('VwReadtags-list', views.VwReadtagsList, name='VwReadtags-list'),

]