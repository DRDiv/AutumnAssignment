import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'package:bookingsapp/src/assets/colors.dart';
import 'package:bookingsapp/src/assets/fonts.dart';
import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:bookingsapp/src/screens/webview.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  GlobalKey _columnKey = GlobalKey();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            ColorSchemes.primaryColor, // Adjust this color as needed
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "BOOKING\$",
              style: FontsCustom.heading.copyWith(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Discover. Book. Enjoy.",
                style: FontsCustom.subHeading.copyWith(color: Colors.white),
              ),
            )
          ],
        ),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ColorSchemes.backgroundColor, ColorSchemes.secondayColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: screenWidth * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorSchemes.backgroundColor,
                    ),
                    child: TextFormField(
                      controller: _username,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: screenWidth * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: _password,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorSchemes.secondayColor,
                    ),
                    onPressed: () async {
                      var admin = await DatabaseQueries.adminLogin(
                        _username.text,
                        _password.text,
                      );

                      if (admin.statusCode == 200) {
                        var response = await DatabaseQueries.getUserDetails(
                          admin.data['userId']!,
                        );
                        ref.read(userLogged.notifier).state =
                            User.set(response.data);

                        final storage = new FlutterSecureStorage();
                        await storage.write(
                          key: "sessionToken",
                          value: admin.data['sessionToken'],
                        );
                        await DatabaseQueries.updateSessionToken(
                          ref.read(userLogged).userId,
                          admin.data['sessionToken']!,
                        );

                        context.go("/homeAdmin");
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(admin.data['message'].toString()),
                          ),
                        );
                      }
                    },
                    child: Text('Login'),
                  ),
                  SizedBox(height: 20),
                  Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                  Text(
                    'For Students',
                    style:
                        FontsCustom.bodyBigText.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: screenWidth * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: TextButton(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              'assets/logo.svg',
                              height: 30,
                              width: 30,
                            ),
                          ),
                          Text(
                            'Login With Channel-i',
                            style: FontsCustom.bodyBigText,
                          ),
                        ],
                      ),
                      onPressed: () {
                        context.go("/webview");
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
