# Generated by Django 4.2.1 on 2023-10-12 12:47

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Calibration',
            fields=[
                ('id', models.BigAutoField(primary_key=True, serialize=False)),
                ('datetime_from', models.DateTimeField()),
                ('datetime_to', models.DateTimeField()),
            ],
            options={
                'db_table': 'base_calibrations',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Chip',
            fields=[
                ('id', models.BigAutoField(primary_key=True, serialize=False)),
                ('name', models.CharField(blank=True, max_length=200, null=True)),
                ('uid', models.CharField(max_length=200)),
                ('created', models.DateTimeField(auto_now_add=True)),
                ('modified', models.DateTimeField(auto_now=True)),
                ('active', models.BooleanField(default=True)),
                ('UUIDs', models.CharField(blank=True, max_length=200, null=True)),
                ('local_name', models.CharField(blank=True, max_length=200, null=True)),
                ('proximity', models.CharField(blank=True, max_length=200, null=True)),
                ('accuracy', models.FloatField(blank=True, null=True)),
                ('minor', models.IntegerField(blank=True, null=True)),
                ('major', models.IntegerField(blank=True, null=True)),
                ('tx_power', models.CharField(blank=True, max_length=200, null=True)),
            ],
            options={
                'db_table': 'base_beacontags',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='LoadedChip',
            fields=[
                ('id', models.BigAutoField(primary_key=True, serialize=False)),
                ('reader_uid', models.CharField(max_length=200)),
                ('tag_uid', models.CharField(max_length=200)),
                ('rssi', models.CharField(max_length=200)),
                ('read_datetime', models.DateTimeField()),
                ('created', models.DateTimeField()),
                ('modified', models.DateTimeField()),
                ('active', models.BooleanField()),
            ],
            options={
                'db_table': 'base_loadedbeacontags',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Position',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=100, unique=True)),
                ('active', models.BooleanField(default=False)),
            ],
            options={
                'db_table': 'base_positions',
                'ordering': ['name'],
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Reader',
            fields=[
                ('id', models.BigAutoField(primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=200, null=True)),
                ('uid', models.CharField(max_length=200)),
                ('last_connected', models.DateTimeField(null=True)),
                ('created', models.DateTimeField(auto_now_add=True)),
                ('modified', models.DateTimeField(auto_now=True)),
                ('active', models.BooleanField(default=True)),
            ],
            options={
                'db_table': 'base_beaconreaders',
                'managed': False,
            },
        ),
    ]
