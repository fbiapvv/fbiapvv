from django.contrib import admin

# Register your models here.

from base.models import BeaconReaders, BeaconTags, LoadedBeaconTags

admin.site.register(BeaconReaders)
admin.site.register(BeaconTags)
admin.site.register(LoadedBeaconTags)
