# Generated by Django 4.0.4 on 2022-09-28 12:21

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('base', '0004_vwreadtags'),
    ]

    operations = [
        migrations.AddField(
            model_name='beaconreaders',
            name='active',
            field=models.IntegerField(default=1),
        ),
        migrations.AddField(
            model_name='beacontags',
            name='active',
            field=models.IntegerField(default=1),
        ),
        migrations.AddField(
            model_name='loadedbeacontags',
            name='active',
            field=models.IntegerField(default=1),
        ),
    ]
