import json
from urllib.parse import urlencode

import requests
from django.shortcuts import get_object_or_404, redirect, render
from django.views import View
from rest_framework import generics
from rest_framework.response import Response

from .models import *
from .serializers import *


class AmenityListView(generics.ListCreateAPIView):
    queryset = Amenity.objects.all()
    serializer_class = AmenitySerializer

class AmenityDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Amenity.objects.all()
    serializer_class = AmenitySerializer

class AmenityByName(generics.RetrieveAPIView):
    queryset = Amenity.objects.all()

    def retrieve(self, request, *args, **kwargs):
        amenityname = self.kwargs.get('username')
        amenity = get_object_or_404(self.get_queryset(), amenityName=amenityname)
        return Response({'amenityId': amenity.amenityId})