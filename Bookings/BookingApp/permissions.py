from django.http import Http404
from django.shortcuts import get_object_or_404
from rest_framework import  permissions
from BookingApp.models import User

class isAuthorized(permissions.BasePermission):
    def has_permission(self, request, view):
        # Ensure that the session token is provided in the request data
        
        session_token = request.data.get('session_token')
        print(request.data)
        if not session_token:
            return False

        try:
            user = get_object_or_404(User, userSession=session_token)
            return True
        except Http404:
            # No user found with the provided token
            return False
class isAdmin(permissions.BasePermission):
    def has_permission(self, request, view):
        # Ensure that the session token is provided in the request data
        
        session_token = request.data.get('session_token')
        print(request.data)
        if not session_token:
            return False
        try:
            user = get_object_or_404(User, userSession=session_token)
            return user.ammenityProvider
        except Http404:
            # No user found with the provided token
            return False
       
        
class isUser(permissions.BasePermission):
    def has_permission(self, request, view):
        # Ensure that the session token is provided in the request data
        session_token = request.data.get('session_token')
        print(request.data)
        if not session_token:
            return False
        try:
             # Assuming you have a User model with an isAdmin field
            user = get_object_or_404(User, userSession=session_token)

            # Check if the user is user
            return not user.ammenityProvider
        except Http404:
            # No user found with the provided token
            return False
       