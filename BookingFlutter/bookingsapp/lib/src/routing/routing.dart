import 'package:bookingsapp/src/screens/adminManage.dart';
import 'package:bookingsapp/src/screens/amenityAdmin.dart';
import 'package:bookingsapp/src/screens/ammenityBooking.dart';
import 'package:bookingsapp/src/screens/eventAdmin.dart';
import 'package:bookingsapp/src/screens/eventBooking.dart';
import 'package:bookingsapp/src/screens/home.dart';
import 'package:bookingsapp/src/screens/homeAdmin.dart';
import 'package:bookingsapp/src/screens/login.dart';
import 'package:bookingsapp/src/screens/teamCreation.dart';
import 'package:bookingsapp/src/screens/teams.dart';
import 'package:bookingsapp/src/screens/teamManagement.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:bookingsapp/src/screens/userProfile.dart';
import 'package:bookingsapp/src/screens/webview.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter router = GoRouter(initialLocation: "/transition", routes: [
  GoRoute(
    path: "/transition",
    pageBuilder: (context, state) {
      return MaterialPage(child: TransitionScreen());
    },
  ),
  GoRoute(
    path: "/login",
    pageBuilder: (context, state) {
      return MaterialPage(child: LoginScreen());
    },
  ),
  GoRoute(
    path: "/home",
    pageBuilder: (context, state) {
      return MaterialPage(child: HomeScreen());
    },
  ),
  GoRoute(
    path: "/homeAdmin",
    pageBuilder: (context, state) {
      return MaterialPage(child: HomeAdmin());
    },
  ),
  GoRoute(
    path: "/adminManage",
    pageBuilder: (context, state) {
      return MaterialPage(child: AdminManage());
    },
  ),
  GoRoute(
    path: "/eventAdmin",
    pageBuilder: (context, state) {
      return MaterialPage(child: EventAdmin());
    },
  ),
  GoRoute(
    path: "/amenityAdmin",
    pageBuilder: (context, state) {
      return MaterialPage(child: AmenityAdmin());
    },
  ),
  GoRoute(
    path: "/webview",
    pageBuilder: (context, state) {
      return MaterialPage(child: WebViewScreen());
    },
  ),
  GoRoute(
    path: "/team",
    pageBuilder: (context, state) {
      return MaterialPage(child: TeamPage());
    },
  ),
  GoRoute(
    path: "/team/:teamId",
    pageBuilder: (context, state) {
      return MaterialPage(
          child: TeamManagementView(state.pathParameters['teamId']!));
    },
  ),
  GoRoute(
    path: "/userProfile/:userId",
    pageBuilder: (context, state) {
      return MaterialPage(child: UserProfile(state.pathParameters['userId']!));
    },
  ),
  GoRoute(
    path: "/eventBooking/:eventId/:teamId",
    pageBuilder: (context, state) {
      return MaterialPage(
          child: EventBooking(state.pathParameters['eventId']!,
              state.pathParameters['teamId']!));
    },
  ),
  GoRoute(
    path: "/amenityBooking/:amenityId",
    pageBuilder: (context, state) {
      return MaterialPage(
          child: AmenityBooking(state.pathParameters['amenityId']!));
    },
  ),
  GoRoute(
    path: "/teamCreation",
    pageBuilder: (context, state) {
      return MaterialPage(child: TeamCreation());
    },
  ),
]);
