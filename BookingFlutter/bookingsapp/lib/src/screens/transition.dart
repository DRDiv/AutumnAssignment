import 'dart:convert';

import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/src/models/user.dart';
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
    print(token);
    try {
      var currentUser = await DatabaseQueries.getCurrentUser(token);

      if (currentUser.statusCode == 200) {
        var response =
            await DatabaseQueries.getUserDetails(currentUser.data['userId']);
        Map<String, dynamic> responseData = response.data;

        User userlogged = User.set(responseData);

        ref.watch(userLogged.notifier).state = userlogged;
        if (userlogged.ammenityProvider) {
          return "/homeAdmin";
        }
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSchemes.primaryColor,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "BOOKING\$",
              style: FontsCustom.heading,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Discover. Book. Enjoy.",
                style: FontsCustom.subHeading,
              ),
            ),
          ],
        ),
        centerTitle: true,
        toolbarHeight: 120, // Increased toolbar height for better alignment
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(ColorSchemes.primaryColor),
            ),
            const SizedBox(height: 20),
            Text(
              "Loading...",
              style: FontsCustom.bodyBigText,
            ),
          ],
        ),
      ),
    );
  }
}
