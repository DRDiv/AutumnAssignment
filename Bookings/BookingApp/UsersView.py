
import json
import os
from urllib.parse import urlencode
from django.http import JsonResponse
from dotenv import load_dotenv

import requests
from django.shortcuts import get_object_or_404, redirect, render
from django.views import View
from rest_framework import generics
from rest_framework.response import Response
from decouple import Config
from .models import *
from .serializers import *

load_dotenv()
ip=os.getenv('ip')

class CustomOAuthAuthorizeView(View):
    def get(self, request):
      
        # oauth_params = {
        #     'client_id': '1XDTUULqBMBdeIy4GyMEBuAwl8CWTjvzeTpr29Hy',
        #     'redirect_uri': ip+'userlogin/',
        #     'state': 'nice',
        # }

        
        # oauth_authorize_url = 'https://channeli.in/oauth/authorise/?' + urlencode(oauth_params)

      
        # return redirect(oauth_authorize_url)
        response=request.GET.get('reponse')
        return response
class UserListView(generics.ListCreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer

class UserLogin(generics.ListCreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    def get(self, request):
            state=request.GET.get('state')
            if (state!='done'):
                oauth_params = {
                    'client_id': '1XDTUULqBMBdeIy4GyMEBuAwl8CWTjvzeTpr29Hy',
                    'redirect_uri': ip+'userlogin/',
                    'state': 'done',
                }

                
                oauth_authorize_url = 'https://channeli.in/oauth/authorise/?' + urlencode(oauth_params)

            
                return redirect(oauth_authorize_url)
            
            redirect_uri = ip+'userlogin/'
            authorization_code = request.GET.get('code')
            # print(authorization_code)

            load_dotenv()
            client_id = '1XDTUULqBMBdeIy4GyMEBuAwl8CWTjvzeTpr29Hy'
            client_secret = os.getenv('client_secret')

           
            token_url = 'https://channeli.in/open_auth/token/?'
            data = {
                'client_id': client_id,
                'client_secret': client_secret,
                'grant_type': 'authorization_code',
                'redirect_uri': redirect_uri,
                'code': authorization_code,
            }
            response = requests.post(token_url, data=data)
        
            if response.status_code == 200:
                
                token_data = response.json()
                access_token = token_data['access_token']
                
            
                user_data_url = 'https://channeli.in/open_auth/get_user_data/?'  
                headers = {
                    'Authorization': f'Bearer {access_token}',
                }
                response = requests.get(user_data_url, headers=headers)

                if response.status_code == 200:
                    user_data = response.json()
                    poster={
                        'userId':user_data['userId'],
                        'userName':user_data['person']['fullName'],
                        'data':json.dumps(user_data),
                        'penalties':0,
                        'ammenityProvider':False,
                    }
                    poster=json.dumps(poster)
                    headers = {
        'Content-Type': 'application/json',
    }
                    record=requests.get(ip+f'user/{user_data["userId"]}')
                
                    if (record.status_code != 200):

                    
                        response = requests.post(ip+'user/?', data=poster,headers=headers)
                    requests.post(ip+'login/?',data=json.dumps({'userId': user_data['userId']}))
                    return JsonResponse({'userId': user_data['userId']})
                     
                else:
                    return redirect(ip+'user/')
            else:
                return redirect(ip+'user/')

class UserDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
class AddPenalty(generics.RetrieveUpdateDestroyAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer

    def get(self, request, *args, **kwargs):
        instance = self.get_object()
        instance.penalties += 1
        instance.save()
        serializer = self.get_serializer(instance)
        return redirect(ip+'user/')

class UserByName(generics.RetrieveAPIView):
    queryset = User.objects.all()

    def retrieve(self, request, *args, **kwargs):
        username = self.kwargs.get('username')
        user = get_object_or_404(self.get_queryset(), userName=username)
        return Response({'userId': user.userId})