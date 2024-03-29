# Generated by Django 4.0.4 on 2022-10-06 17:35

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('base', '0011_beaconreaders_is_setting_reader_and_more'),
    ]

    operations = [
        migrations.CreateModel(
            name='VwTagslastrssi',
            fields=[
                ('id', models.BigIntegerField(primary_key=True, serialize=False)),
                ('name', models.CharField(blank=True, max_length=200, null=True)),
                ('uid', models.CharField(max_length=200, unique=True)),
                ('local_name', models.CharField(blank=True, max_length=200, null=True)),
                ('UUIDs', models.CharField(blank=True, max_length=200, null=True)),
                ('last_rssi', models.IntegerField(blank=True, null=True)),
                ('last_read', models.DateTimeField(auto_now=True)),
                ('created', models.DateTimeField(auto_now_add=True)),
                ('modified', models.DateTimeField(auto_now=True)),
                ('active', models.BooleanField(default=1)),
            ],
            options={
                'db_table': 'vw_tagslastrssi',
                'ordering': ('last_rssi',),
                'managed': False,
            },
        ),
        migrations.RemoveField(
            model_name='beaconreaders',
            name='is_setting_reader',
        ),
        migrations.AddIndex(
            model_name='beaconreaders',
            index=models.Index(fields=['uid'], name='base_beacon_uid_261492_idx'),
        ),
        migrations.AddIndex(
            model_name='beaconreaders',
            index=models.Index(fields=['active'], name='base_beacon_active_f3d1a4_idx'),
        ),
        migrations.AddIndex(
            model_name='beacontags',
            index=models.Index(fields=['uid'], name='base_beacon_uid_f705a7_idx'),
        ),
        migrations.AddIndex(
            model_name='beacontags',
            index=models.Index(fields=['last_read'], name='base_beacon_last_re_bc968e_idx'),
        ),
        migrations.AddIndex(
            model_name='beacontags',
            index=models.Index(fields=['active'], name='base_beacon_active_66b08a_idx'),
        ),
        migrations.AddIndex(
            model_name='loadedbeacontags',
            index=models.Index(fields=['reader_uid'], name='base_loaded_reader__82471b_idx'),
        ),
        migrations.AddIndex(
            model_name='loadedbeacontags',
            index=models.Index(fields=['tag_uid'], name='base_loaded_tag_uid_2b5be2_idx'),
        ),
    ]
