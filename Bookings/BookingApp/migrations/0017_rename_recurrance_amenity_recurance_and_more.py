# Generated by Django 4.2.5 on 2023-12-13 12:00

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('BookingApp', '0016_team_isreq'),
    ]

    operations = [
        migrations.RenameField(
            model_name='amenity',
            old_name='recurrance',
            new_name='recurance',
        ),
        migrations.AlterField(
            model_name='amenity',
            name='amenityPicture',
            field=models.ImageField(blank=True, upload_to='images/amenity/'),
        ),
    ]
