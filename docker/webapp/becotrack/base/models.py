from django.db import models

# Create your models here.

class BeaconReaders(models.Model):
    name = models.CharField(max_length=200, null=True, blank=True)
    uid = models.CharField(max_length=200, unique=True)
    last_connected = models.DateTimeField(null=True, blank=True)
    created = models.DateTimeField(auto_now_add=True) 
    modified = models.DateTimeField(auto_now=True)
    active = models.BooleanField(default=1)
    class Meta:
        indexes = [
            models.Index(fields=['uid',]),
            models.Index(fields=['active',]),
            ]
    

class BeaconTags(models.Model):
    name = models.CharField(max_length=200, null=True, blank=True)
    uid = models.CharField(max_length=200, unique=True)
    local_name = models.CharField(max_length=200, null=True, blank=True)
    UUIDs = models.CharField(max_length=200, null=True, blank=True)
    last_rssi = models.IntegerField(null=True, blank=True)
    last_read = models.DateTimeField(auto_now=True)
    created = models.DateTimeField(auto_now_add=True) 
    modified = models.DateTimeField(auto_now=True)
    active = models.BooleanField(default=1)
    class Meta:
        ordering = ('-last_rssi',)
        indexes = [
            models.Index(fields=['uid',]),
            models.Index(fields=['last_read',]),
            models.Index(fields=['active',]),
            ]


class LoadedBeaconTags(models.Model):
    reader_uid = models.CharField(max_length=200)
    tag_uid = models.CharField(max_length=200)
    rssi = models.CharField(max_length=200)
    read_datetime = models.DateTimeField() 
    created = models.DateTimeField(auto_now_add=True) 
    modified = models.DateTimeField(auto_now=True)
    active = models.BooleanField(default=1)
    class Meta:
        indexes = [
            models.Index(fields=['reader_uid',]),
            models.Index(fields=['tag_uid',]),
            ]
        
class VwReadtags(models.Model):
    id = models.BigIntegerField(primary_key=True)
    read_datetime = models.DateTimeField() 
    reader_name = models.CharField(max_length=200)
    tag_name = models.CharField(max_length=200)
    rssi = models.CharField(max_length=200)
    created = models.DateTimeField() 
    modified = models.DateTimeField()

    class Meta:
            managed = False
            db_table = 'vw_readtags'

class VwTagslastrssi(models.Model):
    id = models.BigIntegerField(primary_key=True)
    name = models.CharField(max_length=200, null=True, blank=True)
    uid = models.CharField(max_length=200, unique=True)
    local_name = models.CharField(max_length=200, null=True, blank=True)
    UUIDs = models.CharField(max_length=200, null=True, blank=True)
    last_rssi = models.IntegerField(null=True, blank=True)
    last_read = models.DateTimeField() 
    created = models.DateTimeField(auto_now_add=True) 
    modified = models.DateTimeField(auto_now=True)
    active = models.BooleanField(default=1)
    class Meta:
        managed = False
        db_table = 'vw_tagslastrssi'
        # ordering = ('last_rssi','uid',)
