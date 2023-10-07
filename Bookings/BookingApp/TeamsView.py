import json
from urllib.parse import urlencode

import requests
from django.shortcuts import get_object_or_404, redirect, render
from django.views import View
from rest_framework import generics
from rest_framework.response import Response

from .models import *
from .serializers import *


class TeamListView(generics.ListCreateAPIView):
    queryset = Team.objects.all()
    serializer_class = TeamSerializer

class TeamDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Team.objects.all()
    serializer_class = TeamSerializer

class TeamByName(generics.RetrieveAPIView):
    queryset = Team.objects.all()

    def retrieve(self, request, *args, **kwargs):
        teamname = self.kwargs.get('username')
        team = get_object_or_404(self.get_queryset(), teamName=teamname)
        return Response({'teamId': team.teamId})
    
class AddUserToTeamView(generics.UpdateAPIView):
    queryset = Team.objects.all()
    serializer_class = TeamSerializer

    def get(self, request, *args, **kwargs):
        team = self.get_object()
        userid = kwargs.get('userId')
        user = get_object_or_404(User, userId=userid)  # Assuming you have a User model

        # Add the user to the team
        team.users.add(user)
        team.isAdmin[user.userId]=False

        serializer = self.get_serializer(team)
        return Response(serializer.data)
class MakeAdmin(generics.UpdateAPIView):
    queryset = Team.objects.all()
    serializer_class = TeamSerializer

    def get(self, request, *args, **kwargs):
        team = self.get_object()
        userid = kwargs.get('userId')
        user = get_object_or_404(User, userId=userid)  # Assuming you have a User model

        # Add the user to the team

        team.isAdmin[user.userId]=True

        serializer = self.get_serializer(team)
        return Response(serializer.data)