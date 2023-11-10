import 'package:bookingsapp/functions/get.dart';
import 'package:bookingsapp/src/assets/colors.dart';
import 'package:bookingsapp/src/assets/fonts.dart';
import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/main.dart';
import 'package:bookingsapp/src/models/team.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WidgetCustom extends StatefulWidget {
  User userlogged;
  String ipAdd;

  WidgetCustom(this.userlogged, this.ipAdd);

  @override
  State<WidgetCustom> createState() => _WidgetCustomState();
}

class _WidgetCustomState extends State<WidgetCustom> {
  late Future<List<Team>> dataIndvFuture;

  @override
  void initState() {
    super.initState();
    setState(() {
      dataIndvFuture = getTeams(widget.userlogged.userId);
    });
  }

  void rebuild() {
    setState(() {
      dataIndvFuture = getTeams(widget.userlogged.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
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
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
          child: FutureBuilder<List<Team>>(
            future: dataIndvFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Center(
                  child: Text("An error occurred."),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "No Teams Found",
                    style: FontsCustom.bodyBigText,
                  ),
                );
              } else {
                List<Team> dataIndv = (snapshot.data ?? []).reversed.toList();
                return ListView.builder(
                  itemCount: dataIndv.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2.0,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(8.0),
                        title: Text(
                          dataIndv[index].teamName,
                          style: FontsCustom.bodyBigText,
                        ),
                        leading:
                            Icon(Icons.group, color: ColorSchemes.primaryColor),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          context.go('/team/${dataIndv[index].teamId}');
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorSchemes.blendColor,
        onPressed: () async {
          await router.push("/teamCreation/");
          rebuild();
        },
        child: Icon(Icons.add),
        tooltip: "Create a New Team",
      ),
      bottomNavigationBar: BottomAppBar(
        color: ColorSchemes.primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: IconButton(
                onPressed: () {
                  context.go("/home");
                },
                icon: Icon(
                  Icons.home,
                  color: ColorSchemes.whiteColor,
                ),
                tooltip: "Home",
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  context.go("/team");
                },
                icon: Icon(
                  Icons.people,
                  color: ColorSchemes.whiteColor,
                ),
                tooltip: "Teams",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamPage extends ConsumerStatefulWidget {
  const TeamPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeamPageState();
}

class _TeamPageState extends ConsumerState<TeamPage> {
  @override
  Widget build(BuildContext context) {
    User userlogged = ref.read(userLogged);
    String ipAdd = ref.read(ip);
    return WidgetCustom(userlogged, ipAdd);
  }
}
