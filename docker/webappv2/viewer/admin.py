from django.contrib import admin
from .models import Chip, Position, Calibration, Reader, LoadedChip


@admin.register(Chip)
class DocumentAdmin(admin.ModelAdmin):
    list_display = ('name', 'id', 'uid', 'created', 'modified', 'active', 'UUIDs',
                    'local_name', 'proximity', 'accuracy', 'minor', 'major', 'tx_power')


@admin.register(Position)
class DocumentAdmin(admin.ModelAdmin):
    list_display = ('name', 'id', 'active')


@admin.register(Calibration)
class DocumentAdmin(admin.ModelAdmin):
    list_display = ('chip', 'id', 'position', 'datetime_from', 'datetime_to')


@admin.register(Reader)
class DocumentAdmin(admin.ModelAdmin):
    list_display = ('name', 'id', 'uid', 'last_connected', 'created', 'modified', 'active')


@admin.register(LoadedChip)
class DocumentAdmin(admin.ModelAdmin):
    list_display = ('id', 'reader_uid', 'tag_uid', 'rssi', 'read_datetime', 'created', 'modified', 'active')
