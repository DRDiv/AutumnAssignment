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
            if query is not None:
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
            print(dateSlot,timeStart)
            for indv in users:
                print(indv)
                userind=get_object_or_404(User.objects.all(),userId=indv)
               
                userobj.append(userind)
                print(userobj)
                query=queryset.filter(  individuals__in=userobj,    amenity=amenity,dateSlot=dateSlot,timeStart__contains=timeStart, ).all()
                print(query)
                if query.count()!=0:
                    return Response({'message':f"Request Already Pending for {userind.userName}"})
            print(request.data)
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



