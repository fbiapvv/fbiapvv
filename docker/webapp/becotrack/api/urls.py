from django.urls import path
from . import views

urlpatterns = [
    path('api/beaconreaders/', views.getBeaconReadersData),
    path('api/beaconreaders/add', views.putBeaconReadersDataAdd),
    path('api/loadedbeacontags/add', views.putLoadedBeaconTags),
]