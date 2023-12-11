import 'package:bookingsapp/src/components/bookedEvents.dart';
import 'package:bookingsapp/src/components/bottomAppBar.dart';
import 'package:bookingsapp/src/components/teamMembers.dart';
import 'package:bookingsapp/src/database/dbRequest.dart';
import 'package:bookingsapp/src/database/dbTeam.dart';
import 'package:bookingsapp/src/models/team.dart';
import 'package:bookingsapp/src/models/user.dart';

import 'package:bookingsapp/src/components/eventSearch.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:bookingsapp/src/screens/userSearch.dart';
import 'package:bookingsapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class TabWidget extends StatefulWidget {
  User userlogged;
  String teamId;

  TabWidget(this.userlogged, this.teamId, {super.key});

  @override
  State<TabWidget> createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget> with TickerProviderStateMixin {
  Team _team = Team.defaultTeam();
  bool _isLoading = true;
  late TabController _tabController;
  int currentTabIndex = 0;
  Future<void> setTeam() async {
    var response = await DatabaseQueriesTeam.getTeamDetails(widget.teamId);
    await _team.setData(response.data);
  }

  Future<void> loadTeamData() async {
    await setTeam();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTeamData();
    setState(() {
      _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
      _tabController.addListener(() {
        setState(() {
          currentTabIndex = _tabController.index;
        });
      });
    });
  }

  void rebuild() {
    setState(() {
      _isLoading = true;
      _team = Team.defaultTeam();
    });
    loadTeamData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: AppTheme.lightTheme(),
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "BOOKING\$",
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(color: Colors.white),
              ),
              centerTitle: true,
              bottom: TabBar(
                controller: _tabController,
                tabs: const [Tab(text: 'Team Members'), Tab(text: 'Events')],
              ),
            ),
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      TeamMembers(_team.users, _team.isAdmin, _team.isReq,
                          widget.userlogged, _team.teamId, rebuild),
                      EventsBooked(_team.events, _team)
                    ],
                  ),
            bottomNavigationBar: BottomAppBarUser(context, widget.userlogged),
            floatingActionButton:
                !_isLoading && _team.isAdmin[widget.userlogged.userId]
                    ? FloatingActionButton(
                        onPressed: () async {
                          if (_tabController.index == 0) {
                            final result = await showDialog(
                                context: context,
                                builder: (context) {
                                  return UserSearch(
                                      context, _team.users, _team.teamId);
                                });
                            if (result == "confirmed") {
                              rebuild();
                            }
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return EventAlertBox(_team);
                                });
                          }
                        },
                        child: const Icon(Icons.add),
                      )
                    : null,
          ),
        ));
  }
}

class TeamManagementView extends ConsumerStatefulWidget {
  final String teamId;
  const TeamManagementView(this.teamId, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TeamManagementViewState();
}

class _TeamManagementViewState extends ConsumerState<TeamManagementView> {
  @override
  Widget build(BuildContext context) {
    User userlogged = ref.read(userLogged);
    return TabWidget(userlogged, widget.teamId);
  }
}
