# Generated by Django 4.2.5 on 2023-10-12 06:38

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('BookingApp', '0009_alter_booking_amenity_alter_booking_event'),
    ]

    operations = [
        migrations.AlterField(
            model_name='booking',
            name='amenity',
            field=models.ForeignKey(blank=True, default=None, null=True, on_delete=django.db.models.deletion.CASCADE, to='BookingApp.amenity'),
        ),
        migrations.AlterField(
            model_name='booking',
            name='event',
            field=models.ForeignKey(blank=True, default=None, null=True, on_delete=django.db.models.deletion.CASCADE, to='BookingApp.event'),
        ),
        migrations.AlterField(
            model_name='booking',
            name='individuals',
            field=models.ForeignKey(blank=True, default=None, null=True, on_delete=django.db.models.deletion.CASCADE, to='BookingApp.user'),
        ),
        migrations.AlterField(
            model_name='booking',
            name='teamId',
            field=models.ForeignKey(blank=True, default=None, null=True, on_delete=django.db.models.deletion.CASCADE, to='BookingApp.team'),
        ),
    ]
