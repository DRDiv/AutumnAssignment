import 'package:bookingsapp/assets/colors.dart';
import 'package:bookingsapp/assets/fonts.dart';
import 'package:bookingsapp/database/database.dart';
import 'package:bookingsapp/models/event.dart';
import 'package:bookingsapp/models/team.dart';
import 'package:bookingsapp/models/user.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TeamMembers extends StatefulWidget {
  List<User> members;
  Map<String, dynamic> isAdmin;
  User userlogged;
  TeamMembers(this.members, this.isAdmin, this.userlogged);

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
                backgroundColor: ColorCustomScheme.backgroundColor,
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
                onPressed: () {},
                child: Text(
                  (user.userName +
                      ((user.userId == widget.userlogged.userId)
                          ? " (You)"
                          : "")),
                )),
            trailing: (widget.isAdmin[widget.userlogged.userId] &&
                    !widget.isAdmin[user.userId])
                ? IconButton(onPressed: () {}, icon: Icon(Icons.add))
                : Text(''),
          );
        });
  }
}

class EventsBooked extends StatefulWidget {
  List<Event> events;
  EventsBooked(this.events);

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

class _TabWidgetState extends State<TabWidget> {
  Team team = Team.defaultTeam();
  bool isLoading = true;

  Future<void> setTeam() async {
    var response = await DatabaseQueries.getTeamDetails(widget.teamId);
    await team.setData(response.data);
  }

  @override
  void initState() {
    super.initState();
    loadTeamData();
  }

  Future<void> loadTeamData() async {
    await setTeam();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorCustomScheme.appBarColor,
          title: Text(
            "BOOKING\$",
            style: FontsCustom.heading,
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [Tab(text: 'Team Members'), Tab(text: 'Events')],
            indicator:
                BoxDecoration(color: ColorCustomScheme.appBarColorSelected),
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  TeamMembers(team.users, team.isAdmin, widget.userlogged),
                  EventsBooked(team.events)
                ],
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
