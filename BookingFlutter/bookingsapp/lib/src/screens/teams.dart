import 'package:bookingsapp/src/components/bottomAppBar.dart';
import 'package:bookingsapp/src/functions/get.dart';

import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/src/models/team.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:bookingsapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class WidgetCustom extends StatefulWidget {
  User userlogged;
  String ipAdd;

  WidgetCustom(this.userlogged, this.ipAdd, {super.key});

  @override
  State<WidgetCustom> createState() => _WidgetCustomState();
}

class _WidgetCustomState extends State<WidgetCustom> {
  late Future<List<Team>> _dataIndvFuture;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dataIndvFuture = getTeams(widget.userlogged.userId);
    });
  }

  void rebuild() {
    setState(() {
      _dataIndvFuture = getTeams(widget.userlogged.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme(),
      home: Scaffold(
          appBar: AppBar(
            elevation: 2.0,
            title: Text(
              "Teams",
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: Colors.white),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
            child: FutureBuilder<List<Team>>(
              future: _dataIndvFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("An error occurred."),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No Teams Found",
                      style: Theme.of(context).textTheme.bodyLarge!,
                    ),
                  );
                } else {
                  List<Team> dataIndv = (snapshot.data ?? []).reversed.toList();

                  return ListView.builder(
                    itemCount: dataIndv.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8.0),
                          title: Text(
                            dataIndv[index].teamName,
                            style: Theme.of(context).textTheme.bodyLarge!,
                          ),
                          leading: const Icon(
                            Icons.group,
                          ),
                          trailing: dataIndv[index]
                                  .isReq[widget.userlogged.userId]
                              ? SizedBox(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            await DatabaseQueries.reqUserTeam(
                                                dataIndv[index].teamId,
                                                widget.userlogged.userId,
                                                true);
                                            rebuild();
                                          },
                                          icon: const Icon(Icons.check)),
                                      IconButton(
                                          onPressed: () async {
                                            await DatabaseQueries.reqUserTeam(
                                                dataIndv[index].teamId,
                                                widget.userlogged.userId,
                                                false);
                                            rebuild();
                                          },
                                          icon: const Icon(Icons.close))
                                    ],
                                  ),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.arrow_forward),
                                  onPressed: () {
                                    context.push(
                                        '/team/${dataIndv[index].teamId}');
                                  },
                                ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await router.push("/teamCreation/");
              rebuild();
            },
            tooltip: "Create a New Team",
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: BottomAppBarUser(context, widget.userlogged)),
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
