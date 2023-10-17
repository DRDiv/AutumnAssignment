
from django.urls import include, path

from .AmmenityView import *
from .BookingsView import *
from .EventsView import *
from .RequestView import *
from .TeamsView import *
from .UsersView import *

urlpatterns = [
    path('user/', UserListView.as_view(), name='user-list'),
    path('userlogin/', UserLogin.as_view(), name='user-login'),
    path('user/by-username/<str:username>/', UserByName.as_view(), name='user-by-name'),
    path('user/<str:pk>/', UserDetailView.as_view(), name='user-detail'),
    path('user/session/<str:userSession>/', UserSessionView.as_view(), name='user-detail'),
    path('login/', CustomOAuthAuthorizeView.as_view(), name='custom_authorize'),
    path('user/<str:pk>/addpenalty', AddPenalty.as_view(), name='add-penalty'),

    path('team/', TeamListView.as_view(), name='team-list'),
    path('team/<str:pk>/', TeamDetailView.as_view(), name='team-detail'),
    path('team/user/<str:user_id>/', TeamUser.as_view(), name='team-user'),
    path('team/by-teamname/<str:teamname>/', TeamByName.as_view(), name='team-by-name'),
    path('team/<int:pk>/adduser/<str:userId>/', AddUserToTeamView.as_view(), name='add-user-to-team'),
    path('team/<int:pk>/makeadmin/<str:userId>/', MakeAdmin.as_view(), name='add-user-to-team'),

    path('request/', RequestListView.as_view(), name='request-list'),
    path('request/<str:pk>/', RequestDetailView.as_view(), name='request-detail'),


    path('event/', EventListView.as_view(), name='event-list'),
    path('event/<str:pk>/', EventDetailView.as_view(), name='event-detail'),
    path('event/by-eventname/<str:eventname>/', EventByName.as_view(), name='event-by-name'),
    path('events/update/<int:pk>/', EventUpdateView.as_view(), name='event-update'),

    path('amenity/', AmenityListView.as_view(), name='amenity-list'),
    path('amenity/<str:pk>/', AmenityDetailView.as_view(), name='amenity-detail'),
    path('ammenity/by-amenityname/<str:amenityname>/', AmenityByName.as_view(), name='amenity-by-name'),

    path('booking/', BookingListView.as_view(), name='booking-list'),
    path('booking/<str:pk>/', BookingDetailView.as_view(), name='booking-detail'),
    path('booking/individual/<str:user_id>/',BookingUserView.as_view(),name='booking-user'),
    path('booking/team/<str:user_id>/',BookingTeamView.as_view(),name='booking-team'),
    
    ]
