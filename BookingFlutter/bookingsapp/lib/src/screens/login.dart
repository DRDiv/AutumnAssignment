import 'package:bookingsapp/src/assets/colors.dart';
import 'package:bookingsapp/src/assets/fonts.dart';
import 'package:bookingsapp/src/screens/webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  GlobalKey _columnKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorCustomScheme.appBarColor,
        title: SizedBox(
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
              )
            ],
          ),
        ),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      backgroundColor: ColorCustomScheme.backgroundColor,
      body: Center(
        child: Container(
          width: 250,
          decoration: BoxDecoration(
              border: Border.all(
            color: Colors.black, // Border color
            width: 2.0, // Border width
          )),
          child: TextButton(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    'assets/logo.svg', // Replace with the path to your SVG file
                    height: 30, // Adjust the height as needed
                    width: 30, // Adjust the width as needed
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
      ),
    );
  }
}
