"""
URL configuration for Ibeacon project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
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
from django.urls import path
from django.conf.urls.static import static
from django.conf import settings
from viewer.views import chip_list, calibration_list, positions, loaded_chips_list, delete_chip, update_chip, \
    create_new_chip, create_chip_flutter, create_new_calibration, update_calibration, delete_calibration_server, \
    update_position,create_new_position, delete_position, get_chip_list, get_position_list, get_calibration_list, \
    create_calibration_flutter, delete_calibration, ongoing_calibration, while_ongoing_calibration_cancel, \
    readers, update_reader, get_csrf_token

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', chip_list, name='upon_start'),
    path('zoznam_čipov/', chip_list, name='chip_list'),
    path('zoznam_kalibrácií/', calibration_list, name='calibration_list'),
    path('pozície/', positions, name='positions'),
    path('načítané_čipy/', loaded_chips_list, name='loaded_chips_list'),
    path('čítačky/', readers, name='readers'),
    path('update_chip/', update_chip, name='update_chip'),
    path('delete_chip/<int:chip_id>/', delete_chip, name='delete_chip'),
    path('create_new_chip/', create_new_chip, name='create_new_chip'),
    path('create_new_calibration/', create_new_calibration, name='create_new_calibration'),
    path('update_calibration/', update_calibration, name='update_calibration'),
    path('delete_calibration_server/<int:calibration_id>/', delete_calibration_server, name='delete_calibration_server'),
    path('update_position/', update_position, name='update_position'),
    path('create_new_position/', create_new_position, name='create_new_position'),
    path('delete_position/<int:position_id>/', delete_position, name='delete_position'),
    path('update_reader/', update_reader, name='update_reader'),
    path('api/get_csrf_token/', get_csrf_token, name='get_csrf_token'),
    path('api/create_chip_flutter/', create_chip_flutter, name='create_chip_flutter'),
    path('api/create_calibration_flutter/', create_calibration_flutter, name='create_calibration_flutter'),
    path('api/delete_calibration/', delete_calibration, name='delete_calibration'),
    path('api/get_chip_list/', get_chip_list, name='get_chip_list'),
    path('api/get_position_list/', get_position_list, name='get_position_list'),
    path('api/get_calibration_list/', get_calibration_list, name='get_calibration_list'),
    path('api/ongoing_calibration/', ongoing_calibration, name='ongoing_calibration'),
    path('api/cancel_calibration/', while_ongoing_calibration_cancel, name='while_ongoing_calibration_cancel'),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
