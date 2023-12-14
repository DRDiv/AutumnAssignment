

from django.shortcuts import get_object_or_404
from rest_framework import generics,status
from rest_framework.response import Response

from BookingApp.permissions import isAdmin, isAuthorized, isUser

from .models import *
from .serializers import *

from datetime import time

def parse_time(time_str):
    time_str = time_str.replace('TimeOfDay(', '').replace(')', '')
    hours, minutes = map(int, time_str.split(':'))
    return time(hours, minutes)
class AmenityListView(generics.CreateAPIView):
    queryset = Amenity.objects.all()
    serializer_class = AmenitySerializer
    permission_classes=[isAdmin]
    def create(self, request, *args, **kwargs):
      
        # userId=request.data.get('userId')
        # amenityName=request.data.get('amenityName')
      
        # recurance=request.data.get('recurance')
        # amenityPicture=request.data.get('amenityPicture')
        # user=get_object_or_404(User.objects.all(),userId=userId)
        
      
        # amenity=Amenity(
        #     amenityName=amenityName,
        #     amenityPicture=amenityPicture,
        #     userProvider=user,
        #     recurrance=recurance,
        #     capacity=capacity,
        # )
        # amenity.save()
        frequency_map={'daily': 'D', 'weekly': 'W', 'monthly': 'M', 'yearly': 'Y', 'onetime': 'O'}
        request.data['recurrence'] = frequency_map.get(request.data.get('recurrence'))
        serializer = self.get_serializer(data=request.data)
        
        serializer.is_valid(raise_exception=False)
        print(serializer.errors)
        user = get_object_or_404(User.objects.all(), userId=request.data.get('userId'))
        amenity=serializer.save(userProvider=user)
        start_times = [parse_time(start_time_str) for start_time_str in request.data.getlist('startTimes')]
        end_times = [parse_time(end_time_str) for end_time_str in request.data.getlist('endTimes')]
        capacity=request.data.get('capacity')
        for index in range(len(start_times)):
            amenitySlot=AmenitySlot(
                amenity=amenity,
                amenityDate=None,
                amenitySlotStart=start_times[index],
                amenitySlotEnd=end_times[index],
                capacity=capacity,
            )
            amenitySlot.save()
        return Response(status=status.HTTP_201_CREATED)
class AmenityDetailView(generics.RetrieveDestroyAPIView):
    queryset = Amenity.objects.all()
    serializer_class = AmenitySerializer
    permission_classes = [isAuthorized]

class AmenityRegex(generics.ListCreateAPIView):
    lookup_field = 'amenityName'
    serializer_class = AmenitySerializer
    permission_classes=[isUser]
    def get_queryset(self):
        substring = self.kwargs.get('amenityName')
        if substring is not None:
            queryset = Amenity.objects.filter(amenityName__icontains=substring)
            print(queryset)
        else:
            queryset = Amenity.objects.all()
        return queryset
class AmmenitySlotTiming(generics.ListCreateAPIView):
    lookup_field = 'amenity'
    serializer_class = AmenitySlotSerializer
    permission_classes=[isUser]
    def get_queryset(self):
        
        amenity = self.kwargs.get('amenityId')
        amenityobj=get_object_or_404(Amenity.objects.all(),amenityId=amenity)
        
        queryset = AmenitySlot.objects.filter(amenity=amenityobj,amenityDate__isnull=True)
        
        return queryset
class AmmenityUserProvider(generics.ListCreateAPIView):
    lookup_field ='userProvider'
    serializer_class=AmenitySerializer
    permission_classes=[isAdmin]
    def get_queryset(self):
        userProvider = self.kwargs.get('userProvider')
        user=get_object_or_404(User.objects.all(),userId=userProvider)
        
        queryset = Amenity.objects.filter(userProvider=user)
        
        return queryset
