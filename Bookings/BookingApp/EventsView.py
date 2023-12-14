from django.shortcuts import get_object_or_404
from rest_framework import generics
from rest_framework.response import Response
from BookingApp.permissions import isAdmin, isAuthorized, isUser
from .models import *
from .serializers import *
from rest_framework import generics, status

class EventListView(generics.CreateAPIView):
    queryset = Event.objects.all()
    serializer_class = EventSerializer
    permission_classes = [isAdmin]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        
        user = get_object_or_404(User.objects.all(), userId=request.data.get('userId'))
        event = serializer.save(userProvider=user)

        return Response(status=status.HTTP_201_CREATED)
    def post(self, request, *args, **kwargs):
        return self.create(request, *args, **kwargs)

class EventDetailView(generics.RetrieveDestroyAPIView):
    queryset = Event.objects.all()
    serializer_class = EventSerializer
    permission_classes = [isAuthorized]


    
class EventUpdateView(generics.UpdateAPIView):
    queryset = Event.objects.all()
    serializer_class = EventSerializer
    permission_classes = [isAdmin]
    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data)
    
class EventRegex(generics.ListAPIView):
    lookup_field = 'eventName'
    serializer_class = EventSerializer
    permission_classes=[isUser]
    def get_queryset(self):
        substring = self.kwargs.get('eventName')
        if substring is not None:
            queryset = Event.objects.filter(eventName__icontains=substring, eventDate__gt=timezone.now())
        else:
            queryset = Event.objects.all()
        return queryset 
class EventUserProvider(generics.ListAPIView):
    lookup_field ='userProvider'
    serializer_class=EventSerializer
    permission_classes = [isAdmin]

    def get_queryset(self):
        userProvider = self.kwargs.get('userProvider')
        user=get_object_or_404(User.objects.all(),userId=userProvider)
        
        queryset = Event.objects.filter(userProvider=user)
        
        return queryset
