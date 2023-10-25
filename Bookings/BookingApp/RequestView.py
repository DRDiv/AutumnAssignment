from datetime import datetime
import json
from urllib.parse import urlencode
import uuid
from rest_framework import status
import requests
from django.shortcuts import get_object_or_404, redirect, render
from django.views import View
from rest_framework import generics
from rest_framework.response import Response

from .models import *
from .serializers import *


class RequestListView(generics.ListCreateAPIView):
    queryset = Request.objects.all()
    serializer_class = RequestSerializer
    def post(self, request):
        queryset = Request.objects.all()
        
        event_id = request.data.get('event_id') 
      
        if(event_id!=None):
            team_id = request.data.get('team_id') 
        
            
            payment_image = request.data.get('payment_image') 

            
           

            team=get_object_or_404(Team.objects.all(),teamId=team_id)
            event=get_object_or_404(Event.objects.all(),eventId=event_id)
            query=queryset.filter(teamId=team).filter(event=event).all()
            print(query)
            if query :
                return Response({"message": "Request already pending"})
            request = Request(
               
                event=event,
                teamId=team,
                capacity=team.users.count(),
                timeRequest=timezone.now(),
                payment=payment_image,
                userProvider=event.userProvider.userId
            )

            request.save()

           
        else:
           
            amenity_id=request.data.get('amenity_id')
            amenity=get_object_or_404(Amenity.objects.all(),amenityId=amenity_id)
            users=request.data.getlist('users')
            date=request.data.get('date')
            time=request.data.get('timeStart')
            userobj=[]
            date_time_format = "%Y-%m-%d %H:%M:%S.%f"
            dateSlot = datetime.strptime(date, date_time_format).date()
             
            timeStart = datetime.strptime(time, date_time_format).time()
          
            for indv in users:
                print(indv)
                userind=get_object_or_404(User.objects.all(),userId=indv)
               
                userobj.append(userind)
               
                query=queryset.filter(  individuals__in=userobj,    amenity=amenity,dateSlot=dateSlot,timeStart__contains=timeStart, ).all()
                
                if query.count()!=0:
                    return Response({'message':f"Request Already Pending for {userind.userName}"})
           
            request = Request(
               
                amenity=amenity,
                timeRequest=timezone.now(),
                capacity=len(users),
                
                dateSlot=dateSlot,
                timeStart=timeStart,
                userProvider=amenity.userProvider.userId

            )
            
            request.save()
            request.individuals.set(userobj)
        return Response({"message": "Request created successfully"}, status=status.HTTP_201_CREATED)


class RequestDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Request.objects.all()
    serializer_class = RequestSerializer
class RequestProvider(generics.ListAPIView):
    lookup_field = "userProvider"
    serializer_class = RequestSerializer

    def get_queryset(self):
        userId = self.kwargs['userProvider']
        queryset = Request.objects.filter(userProvider=userId)
        return queryset
class RequestToBooking(generics.RetrieveUpdateDestroyAPIView):
    queryset=Request.objects.all()
    serializer_class = RequestSerializer

    def get(self, request, *args, **kwargs):
        requestObj = self.get_object()

        
       
        
       
        booking = Booking(
                event=requestObj.event,
            amenity=requestObj.amenity,
            timeRequest=requestObj.timeRequest,
            capacity=requestObj.capacity,
            teamId=requestObj.teamId,
            dateSlot=requestObj.dateSlot,
    timeStart=requestObj.timeStart,
            verified=False
        )
        booking.save()   
        for individual in requestObj.individuals.all():
                booking.individuals.add(individual)  
        requestObj.delete()    
        if booking.event is not None and booking.teamId is not None:
            team = Team.objects.get(pk=booking.teamId)
            team.bookedEvents.add(booking.event)
            team.save()   
        return Response( status=status.HTTP_201_CREATED)
        




