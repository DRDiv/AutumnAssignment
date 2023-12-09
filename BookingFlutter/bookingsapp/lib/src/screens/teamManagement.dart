import 'package:bookingsapp/src/assets/colors.dart';
import 'package:bookingsapp/src/assets/fonts.dart';
import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/src/models/event.dart';
import 'package:bookingsapp/src/models/team.dart';
import 'package:bookingsapp/src/models/user.dart';

import 'package:bookingsapp/src/screens/eventSearch.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:bookingsapp/src/screens/userSearch.dart';
import 'package:bookingsapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TeamMembers extends StatefulWidget {
  List<User> members;
  Map<String, dynamic> isAdmin;
  Map<String, dynamic> isReq;
  User userlogged;
  String teamId;
  Function rebuild;
  TeamMembers(this.members, this.isAdmin, this.isReq, this.userlogged,
      this.teamId, this.rebuild);

  @override
  State<TeamMembers> createState() => TeamMembersState();
}

class TeamMembersState extends State<TeamMembers> {
  @override
  Widget build(BuildContext context) {
    final reversedMembers = widget.members.reversed.toList();
    return ListView.builder(
        itemCount: reversedMembers.length,
        itemBuilder: (context, index) {
          User user = reversedMembers[index];

          return ListTile(
            leading: CircleAvatar(
                backgroundColor: ColorSchemes.whiteColor,
                radius: 20.0,
                child: (user.data['person'] == null ||
                        user.data['person']['displayPicture'] == null)
                    ? const Icon(Icons.person, size: 40, color: Colors.black)
                    : ClipOval(
                        child: Image.network(
                        "https://channeli.in/" +
                            user.data['person']['displayPicture'],
                        width: 40.0,
                        height: 40.0,
                        fit: BoxFit.cover,
                      ))),
            title: TextButton(
                onPressed: () {
                  final router = GoRouter.of(context);
                  router.push("/userProfile/${user.userId}");
                },
                child: Text(
                  (user.userName +
                      ((user.userId == widget.userlogged.userId)
                          ? " (You)"
                          : "") +
                      ((widget.isReq[user.userId]) ? " (Req)" : "")),
                )),
            trailing: (widget.isAdmin[widget.userlogged.userId] &&
                    !widget.isAdmin[user.userId])
                ? IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: ElevatedButton(
                                  onPressed: () async {
                                    await DatabaseQueries.addAdmin(
                                        widget.teamId, user.userId);
                                    widget.rebuild();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Confirm')),
                              backgroundColor: ColorSchemes.primaryColor,
                            );
                          });
                    },
                    icon: Icon(Icons.add))
                : Text(''),
          );
        });
  }
}

class EventsBooked extends StatefulWidget {
  List<Event> events;
  Team team;
  EventsBooked(this.events, this.team);

  @override
  State<EventsBooked> createState() => _EventsBookedState();
}

class _EventsBookedState extends State<EventsBooked> {
  @override
  Widget build(BuildContext context) {
    final eventsReversed = widget.events.reversed.toList();
    return ListView.builder(
        itemCount: eventsReversed.length,
        itemBuilder: (context, index) {
          final eventInd = eventsReversed[index];
          DateTime inputDateTime = DateTime.parse(eventInd.eventDate);

          String formattedDateTime =
              DateFormat.yMMMMd().add_jm().format(inputDateTime);
          return ListTile(
            leading: (eventInd.eventPicture == "")
                ? const Icon(Icons.alarm, size: 30, color: Colors.black)
                : ClipOval(
                    child: Image.network(
                    eventInd.eventPicture,
                    width: 30.0,
                    height: 30.0,
                    fit: BoxFit.cover,
                  )),
            title: Text(eventInd.eventName),
            trailing: Text(formattedDateTime),
          );
        });
  }
}

class TabWidget extends StatefulWidget {
  User userlogged;
  String teamId;

  TabWidget(this.userlogged, this.teamId);

  @override
  State<TabWidget> createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget> with TickerProviderStateMixin {
  Team _team = Team.defaultTeam();
  bool _isLoading = true;
  late TabController _tabController;
  int currentTabIndex = 0;
  Future<void> setTeam() async {
    var response = await DatabaseQueries.getTeamDetails(widget.teamId);
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
                style: FontsCustom.heading,
              ),
              centerTitle: true,
              bottom: TabBar(
                controller: _tabController,
                tabs: [Tab(text: 'Team Members'), Tab(text: 'Events')],
              ),
            ),
            body: _isLoading
                ? Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      TeamMembers(_team.users, _team.isAdmin, _team.isReq,
                          widget.userlogged, _team.teamId, rebuild),
                      EventsBooked(_team.events, _team)
                    ],
                  ),
            bottomNavigationBar: BottomAppBar(
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
                        color: ColorSchemes.backgroundColor,
                      )),
                ),
                Expanded(
                  child: IconButton(
                      onPressed: () {
                        context.go("/team");
                      },
                      icon: Icon(
                        Icons.people,
                        color: ColorSchemes.backgroundColor,
                      )),
                )
              ],
            )),
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
                        child: Icon(Icons.add),
                        backgroundColor: ColorSchemes.secondayColor,
                      )
                    : null,
          ),
        ));
  }
}

class TeamManagementView extends ConsumerStatefulWidget {
  final String teamId;
  TeamManagementView(this.teamId);

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
