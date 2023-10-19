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
        print(request.data)
        event_id = request.data.get('event_id') 
        team_id = request.data.get('team_id') 
       
        
        payment_image = request.data.get('payment_image') 

        
        request_id = str(uuid.uuid4())

        team=get_object_or_404(Team.objects.all(),teamId=team_id)
        event=get_object_or_404(Event.objects.all(),eventId=event_id)
        query=queryset.filter(teamId=team).filter(event=event).all()
        if query is not None:
            return Response({"message": "Request already pending"})
        request = Request(
            requestId=request_id,
            event=event,
            teamId=team,
            capacity=team.users.count(),
            timeRequest=timezone.now(),
            payment=payment_image
        )

        request.save()

        return Response({"message": "Request created successfully"}, status=status.HTTP_201_CREATED)


class RequestDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Request.objects.all()
    serializer_class = RequestSerializer



