from django.db.models import *


class Chip(Model):
    id = BigAutoField(primary_key=True)
    name = CharField(max_length=200, blank=True, null=True)
    uid = CharField(max_length=200)
    created = DateTimeField()
    modified = DateTimeField()
    active = BooleanField(default=True)
    UUIDs = CharField(max_length=200, blank=True, null=True)
    local_name = CharField(max_length=200, blank=True, null=True)
    proximity = CharField(max_length=200, blank=True, null=True)
    accuracy = FloatField(blank=True, null=True)
    minor = IntegerField(blank=True, null=True)
    major = IntegerField(blank=True, null=True)
    tx_power = CharField(max_length=200, null=True, blank=True)

    def __str__(self):
        return self.local_name

    class Meta:
        db_table = 'base_beacontags'
        managed = False


class Position(Model):
    name = CharField(max_length=100, unique=True, blank=False, null=False)
    active = BooleanField(default=False)
    created = DateTimeField()
    modified = DateTimeField()

    def __str__(self):
        return self.name

    class Meta:
        ordering = ['name']
        db_table = 'base_positions'
        managed = False


class Calibration(Model):
    id = BigAutoField(primary_key=True)
    chip = ForeignKey(Chip, on_delete=CASCADE)
    position = ForeignKey(Position, on_delete=CASCADE)
    created = DateTimeField()
    modified = DateTimeField()
    datetime_from = DateTimeField()
    datetime_to = DateTimeField()

    def __str__(self):
        return f"{self.chip.name} - position {self.position.name}"

    class Meta:
        db_table = 'base_calibrations'
        managed = False


class Reader(Model):
    id = BigAutoField(primary_key=True)
    name = CharField(max_length=200, null=True)
    uid = CharField(max_length=200)
    last_connected = DateTimeField(null=True)
    created = DateTimeField()
    modified = DateTimeField()
    active = BooleanField(default=True)

    def __str__(self):
        return self.name

    class Meta:
        db_table = 'base_beaconreaders'
        managed = False


class LoadedChip(Model):
    id = BigAutoField(primary_key=True)
    reader_uid = CharField(max_length=200)
    tag_uid = CharField(max_length=200)
    rssi = CharField(max_length=200)
    read_datetime = DateTimeField()
    created = DateTimeField()
    modified = DateTimeField()
    active = BooleanField()

    def __str__(self):
        return f"Chip uid {self.tag_uid} reader {self.reader_uid}"

    class Meta:
        db_table = 'base_loadedbeacontags'
        managed = False
