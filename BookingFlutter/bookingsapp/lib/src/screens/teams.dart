import 'package:bookingsapp/src/components/bottomAppBar.dart';
import 'package:bookingsapp/src/components/teamCard.dart';
import 'package:bookingsapp/src/database/dbTeam.dart';
import 'package:bookingsapp/src/functions/setters.dart';

import 'package:bookingsapp/src/models/team.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:bookingsapp/src/providers/userLoggedProvider.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:bookingsapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WidgetCustom extends StatefulWidget {
  final User userlogged;

  const WidgetCustom(this.userlogged, {super.key});

  @override
  State<WidgetCustom> createState() => _WidgetCustomState();
}

class _WidgetCustomState extends State<WidgetCustom> {
  late Future<List<Team>> _dataIndvFuture;
  final TextEditingController _searchController = TextEditingController();
  List<Team> _dataIndv = [];
  @override
  void initState() {
    super.initState();

    setState(() {
      _dataIndvFuture = getTeams(widget.userlogged.userId);
    });
  }

  void rebuild() {
    setState(() {
      _searchController.text = "";
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
                  .displayMedium!
                  .copyWith(color: Colors.white),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                      hintText: 'Search',
                    ),
                    textAlign: TextAlign.left,
                    onChanged: (query) {
                      setState(() {
                        _dataIndv = (query.isEmpty)
                            ? _dataIndv
                            : setFilterTeams(_dataIndv, query);
                      });
                    },
                  ),
                ),
                Expanded(
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.warning,
                                size: 50,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "No Teams Found",
                                style: Theme.of(context).textTheme.bodyLarge!,
                              ),
                            ],
                          ),
                        );
                      } else {
                        if (_searchController.text.isEmpty) {
                          _dataIndv = (snapshot.data ?? []).reversed.toList();
                        }

                        return ListView.builder(
                          itemCount: _dataIndv.length,
                          itemBuilder: (context, index) {
                            return TeamCard(
                              teamData: _dataIndv[index],
                              userlogged: widget.userlogged,
                              rebuild: rebuild,
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: ElevatedButton(
            onPressed: () async {
              await router.push("/teamCreation/");
              rebuild();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add),
                SizedBox(width: 8.0),
                Text('CREATE TEAM'),
              ],
            ),
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

    return WidgetCustom(userlogged);
  }
}
