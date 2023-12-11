import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

// ignore: non_constant_identifier_names
Container ChannelIButton(BuildContext context, double screenWidth) {
  return Container(
    width: screenWidth * 0.55,
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
        context.go("/webview");
      },
    ),
  );
}
