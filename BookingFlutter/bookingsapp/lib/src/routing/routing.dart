import 'package:bookingsapp/src/screens/adminManage.dart';
import 'package:bookingsapp/src/screens/adminProfile.dart';
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
    path: "/home",
    pageBuilder: (context, state) {
      return CustomTransitionPage(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return FadeTransition(
              opacity: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 750),
          child: HomeScreen());
    },
  ),
  GoRoute(
    path: "/team",
    pageBuilder: (context, state) {
      return CustomTransitionPage(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return FadeTransition(
              opacity: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 750),
          child: TeamPage());
    },
  ),
  GoRoute(
    path: "/team/:teamId",
    pageBuilder: (context, state) {
      return CustomTransitionPage(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 750),
          child: TeamManagementView(state.pathParameters['teamId']!));
    },
  ),
  GoRoute(
    path: "/userProfile/:userId",
    pageBuilder: (context, state) {
      return CustomTransitionPage(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 750),
          child: UserProfile(state.pathParameters['userId']!));
    },
  ),
  GoRoute(
    path: "/eventBooking/:eventId/:teamId",
    pageBuilder: (context, state) {
      return CustomTransitionPage(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 750),
          child: EventBooking(state.pathParameters['eventId']!,
              state.pathParameters['teamId']!));
    },
  ),
  GoRoute(
    path: "/amenityBooking/:amenityId",
    pageBuilder: (context, state) {
      return CustomTransitionPage(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 750),
          child: AmenityBooking(state.pathParameters['amenityId']!));
    },
  ),
  GoRoute(
    path: "/teamCreation",
    pageBuilder: (context, state) {
      return CustomTransitionPage(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return FadeTransition(
              opacity: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 750),
          child: TeamCreation());
    },
  ),
  GoRoute(
    path: "/homeAdmin",
    pageBuilder: (context, state) {
      return CustomTransitionPage(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 750),
          child: HomeAdmin());
    },
  ),
  GoRoute(
    path: "/adminManage",
    pageBuilder: (context, state) {
      return CustomTransitionPage(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return FadeTransition(
              opacity: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 750),
          child: AdminManage());
    },
  ),
  GoRoute(
    path: "/eventAdmin",
    pageBuilder: (context, state) {
      return CustomTransitionPage(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return FadeTransition(
              opacity: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 750),
          child: EventAdmin());
    },
  ),
  GoRoute(
    path: "/amenityAdmin",
    pageBuilder: (context, state) {
      return CustomTransitionPage(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return FadeTransition(
              opacity: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 750),
          child: AmenityAdmin());
    },
  ),
  GoRoute(
    path: "/adminProfile",
    pageBuilder: (context, state) {
      return CustomTransitionPage(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 750),
          child: AdminProfile());
    },
  ),
  GoRoute(
    path: "/webview",
    pageBuilder: (context, state) {
      return CustomTransitionPage(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 750),
          child: WebViewScreen());
    },
  ),
  GoRoute(
    path: "/transition",
    pageBuilder: (context, state) {
      return CustomTransitionPage(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 750),
          child: TransitionScreen());
    },
  ),
  GoRoute(
    path: "/login",
    pageBuilder: (context, state) {
      return CustomTransitionPage(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 750),
          child: LoginScreen());
    },
  ),
]);
