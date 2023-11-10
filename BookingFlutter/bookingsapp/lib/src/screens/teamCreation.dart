import 'dart:convert';
import 'dart:io';

import 'package:bookingsapp/src/assets/colors.dart';
import 'package:bookingsapp/src/assets/fonts.dart';
import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/src/models/ammenity.dart';

import 'package:bookingsapp/src/routing/routing.dart';
import 'package:bookingsapp/src/screens/groupMembers.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class TeamCreation extends ConsumerStatefulWidget {
  TeamCreation();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeamCreationState();
}

class _TeamCreationState extends ConsumerState<TeamCreation> {
  TextEditingController _text = TextEditingController();
  List<String> users = [];

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      users.add(ref.read(userLogged).userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSchemes.primaryColor,
        title: Text(
          "BOOKING\$",
          style: FontsCustom.heading,
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ColorSchemes.tertiaryColor, ColorSchemes.whiteColor],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter Team Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  controller: _text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a team name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorSchemes.secondayColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () async {
                    users = await showDialog(
                      context: context,
                      builder: (context) {
                        return GroupMembers(context, users);
                      },
                    );
                  },
                  child: Text("Add Team Members"),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorSchemes.secondayColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      print(_text.text);
                      await DatabaseQueries.createTeam(
                        _text.text,
                        users,
                        ref.read(userLogged).userId,
                      );
                      router.pop();
                    }
                  },
                  child: Text('Create Team'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
