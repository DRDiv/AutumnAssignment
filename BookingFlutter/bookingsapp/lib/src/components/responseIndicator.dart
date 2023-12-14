import 'dart:convert';

import 'package:bookingsapp/src/routing/routing.dart';
import 'package:flutter/material.dart';

void showResponseDialog(BuildContext context, dynamic response) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        content: IntrinsicHeight(
          child: SizedBox(
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  json.decode(response.toString())['message'],
                  style: Theme.of(context).textTheme.bodyLarge!,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    router.pop();
                    if (json.decode(response.toString())['code'] == 200) {
                      router.pop();
                    }
                  },
                  child: const Text("OK"),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
