import 'dart:convert';

import 'package:bookingsapp/database/database.dart';
import 'package:bookingsapp/main.dart';
import 'package:bookingsapp/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

final userLogged = StateProvider<User>((ref) => User.defaultUser());

class TransitionScreen extends ConsumerStatefulWidget {
  const TransitionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransitionScreenState();
}

class _TransitionScreenState extends ConsumerState<TransitionScreen> {
  String initialLocation = "";
  Future<String> InitialLocation() async {
    final storage = new FlutterSecureStorage();

    String token = await storage.read(key: "sessionToken") ?? " ";

    try {
      var currentUser = await DatabaseQueries.getCurrentUser(token);

      if (currentUser.statusCode == 200) {
        var response =
            await DatabaseQueries.getUserDetails(currentUser.data['userId']);
        Map<String, dynamic> responseData = response.data;

        User userlogged = User.set(responseData);

        ref.watch(userLogged.notifier).state = userlogged;
        return "/home";
      } else if (currentUser.statusCode == 404) {
        return "/login";
      } else {
        return "/login";
      }
    } catch (e) {
      return "/login";
    }
  }

  Future<void> setLocation() async {
    initialLocation = await InitialLocation();
    context.go(initialLocation);
  }

  void initState() {
    super.initState();
    setLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
