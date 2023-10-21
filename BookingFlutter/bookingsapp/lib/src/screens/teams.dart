import 'package:bookingsapp/assets/colors.dart';
import 'package:bookingsapp/assets/fonts.dart';
import 'package:bookingsapp/database/database.dart';
import 'package:bookingsapp/main.dart';
import 'package:bookingsapp/models/user.dart';
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
  late Future<List<String>> dataIndvFuture;
  List<String> teamIds = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      dataIndvFuture = getTeams();
    });
  }

  void rebuild() {
    setState(() {
      dataIndvFuture = getTeams();
    });
  }

  Future<List<String>> getTeams() async {
    try {
      var response =
          await DatabaseQueries.getUserTeams(widget.userlogged.userId);

      if (response.statusCode == 200) {
        List<String> typedData = [];

        for (var responseInd in response.data) {
          typedData.add(responseInd['teamName']);
          teamIds.add(responseInd['teamId']);
        }

        return typedData;
      }
    } catch (e) {
      print(e);
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorCustomScheme.appBarColor,
        title: Text(
          "BOOKING\$",
          style: FontsCustom.heading,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
        child: FutureBuilder<List<String>>(
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
                List<String> dataIndv = snapshot.data ?? [];
                return ListView.builder(
                    itemCount: dataIndv.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: ColorCustomScheme.tileColor),
                            ),
                            child: TextButton(
                              child: Text(
                                dataIndv[index],
                                style: FontsCustom.bodyBigText,
                              ),
                              onPressed: () {
                                context.go('/team/${teamIds[index]}');
                              },
                            )),
                      );
                    });
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await router.push("/teamCreation/");
          rebuild();
        },
        backgroundColor: ColorCustomScheme.appBarColor,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
          color: ColorCustomScheme.appBarColor,
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
                      color: ColorCustomScheme.backgroundColor,
                    )),
              ),
              Expanded(
                child: IconButton(
                    onPressed: () {
                      context.go("/team");
                    },
                    icon: Icon(
                      Icons.people,
                      color: ColorCustomScheme.backgroundColor,
                    )),
              )
            ],
          )),
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
