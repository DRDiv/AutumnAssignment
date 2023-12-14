
from rest_framework import generics

from BookingApp.permissions import isAuthorized

from .models import *
from .serializers import *
from django.utils import timezone
from django.db.models import Q




class BookingUserView(generics.ListCreateAPIView):
    
    serializer_class = BookingSerializer
    permission_classes=[isAuthorized]
    def get_queryset(self):
        user_id = self.kwargs['user_id']
        queryset = Booking.objects.filter(
            Q(individuals=user_id) &
            (Q(event__isnull=False, event__eventDate__gte=timezone.now()) |
             Q(amenity__isnull=False, dateSlot__gte=timezone.now().date()))
        )
        return queryset

class BookingTeamView(generics.ListCreateAPIView):
    serializer_class = BookingSerializer
    permission_classes=[isAuthorized]
    def get_queryset(self):
        user_id = self.kwargs['user_id']  

      
        try:
            user_teams = Team.objects.filter(users__userId=user_id)
        except Team.DoesNotExist:
            user_teams = []

      
        bookings = Booking.objects.filter(teamId__in=user_teams)
        return bookings