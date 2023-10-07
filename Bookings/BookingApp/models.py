
from django.core.validators import *
from django.db import models
from django.utils import timezone


# Create your models here.
class User(models.Model):
    userId=models.CharField(max_length=100,primary_key=True,default='0')
    userName=models.CharField(max_length=100)
    data=models.JSONField(default=dict)
    penalties=models.IntegerField(default=0)
    ammenityProvider=models.BooleanField(default=False)

class Event(models.Model):
    eventId=models.CharField(max_length=100,primary_key=True,default='0')
    eventName=models.CharField(max_length=100)
    eventPicture=models.ImageField(upload_to='images/events/',null=True)
    eventDate=models.DateTimeField(default=timezone.now)
    userProvider=models.ForeignKey(User,on_delete=models.CASCADE,null=True)
    minTeamSize=models.IntegerField(validators=[MinValueValidator(1)] ,default=1)
    maxTeamSize=models.IntegerField(default=1)
    payment=models.DecimalField(default=0,decimal_places=2,max_digits=10)

class Amenity(models.Model):
    amenityId=models.CharField(max_length=100,primary_key=True,default='0')
    amenityName=models.CharField(max_length=100)
    amenityPicture=models.ImageField(upload_to='images/amenity/',null=True)
    amenityDate=models.DateTimeField(default=timezone.now)
    recurrance=models.CharField(default='D',choices=[('D','daily'),('W','weekly'),('M','monthly'),('Y','yearly'),('O','onetime')])
    userProvider=models.ForeignKey(User, on_delete=models.CASCADE,null=True)
    capacity=models.IntegerField(validators=[MinValueValidator(1)],default=1 )

class Team(models.Model):
    teamId=models.CharField(max_length=100,primary_key=True,default='0')
    teamName=models.CharField(max_length=100)
    users=models.ManyToManyField(User)
    isAdmin=models.JSONField(default=dict,blank=True)
    bookedEvents=models.ManyToManyField(Event,blank=True)

class Request(models.Model):
    requestId=models.CharField(max_length=100,primary_key=True,default='0')
    event=models.ForeignKey(Event, on_delete=models.CASCADE)
    amenity=models.ForeignKey(Amenity, on_delete=models.CASCADE)
    timeRequest=models.DateTimeField(default=timezone.now)
    capacity=models.IntegerField(validators=[MinValueValidator(1)],default=1 )
    payment=models.ImageField(upload_to='images/payments/',null=True)
    teamId=models.ForeignKey(Team, on_delete=models.CASCADE)
    individuals=models.ManyToManyField(User,blank=True)

class Booking(models.Model):
    bookingId=models.CharField(max_length=100,primary_key=True,default='0')
    event=models.ForeignKey(Event, on_delete=models.CASCADE)
    amenity=models.ForeignKey(Amenity, on_delete=models.CASCADE)
    timeRequest=models.DateTimeField(default=timezone.now)
    capacity=models.IntegerField(validators=[MinValueValidator(1)] ,default=1)
    teamId=models.ForeignKey(Team, on_delete=models.CASCADE,default=None)
    individuals=models.ForeignKey(User,on_delete=models.CASCADE,default=None)
    verified=models.BooleanField(default=False)





