# Generated by Django 4.2.5 on 2023-10-11 16:09

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('BookingApp', '0006_alter_amenity_amenitypicture'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='amenity',
            name='location',
        ),
        migrations.RemoveField(
            model_name='event',
            name='location',
        ),
        migrations.AddField(
            model_name='user',
            name='userSession',
            field=models.CharField(blank=True, max_length=100),
        ),
        migrations.AlterField(
            model_name='amenity',
            name='amenityPicture',
            field=models.ImageField(blank=True, upload_to='images/amenity/'),
        ),
        migrations.AlterField(
            model_name='booking',
            name='teamId',
            field=models.ForeignKey(default=None, on_delete=django.db.models.deletion.CASCADE, to='BookingApp.team'),
        ),
        migrations.AlterField(
            model_name='request',
            name='payment',
            field=models.ImageField(null=True, upload_to='images/payments/'),
        ),
        migrations.AlterField(
            model_name='request',
            name='teamId',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='BookingApp.team'),
        ),
    ]
