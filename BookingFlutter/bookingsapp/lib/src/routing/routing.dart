import 'package:bookingsapp/src/screens/home.dart';
import 'package:bookingsapp/src/screens/login.dart';
import 'package:bookingsapp/src/screens/teams.dart';
import 'package:bookingsapp/src/screens/teammanagement.dart';
import 'package:bookingsapp/src/screens/transition.dart';
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
  )
]);
