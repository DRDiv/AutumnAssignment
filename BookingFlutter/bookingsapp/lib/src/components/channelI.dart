import 'package:bookingsapp/src/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: non_constant_identifier_names
Container ChannelIButton(BuildContext context, double screenWidth) {
  return Container(
    width: screenWidth * 0.55,
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.blue,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: TextButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/logo.svg',
              height: 30,
              width: 30,
            ),
          ),
          const Text('Login With Channeli'),
        ],
      ),
      onPressed: () {
        router.push("/webview");
      },
    ),
  );
}
