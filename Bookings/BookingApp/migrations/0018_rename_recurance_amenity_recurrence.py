# Generated by Django 4.2.5 on 2023-12-13 12:35

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('BookingApp', '0017_rename_recurrance_amenity_recurance_and_more'),
    ]

    operations = [
        migrations.RenameField(
            model_name='amenity',
            old_name='recurance',
            new_name='recurrence',
        ),
    ]
