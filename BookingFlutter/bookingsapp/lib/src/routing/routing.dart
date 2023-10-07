import 'package:bookingsapp/src/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter router = GoRouter(initialLocation: "/login", routes: [
  GoRoute(
    path: "/login",
    pageBuilder: (context, state) {
      return MaterialPage(child: LoginScreen());
    },
  )
]);
