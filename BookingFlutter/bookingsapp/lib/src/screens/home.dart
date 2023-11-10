import 'package:bookingsapp/functions/get.dart';
import 'package:bookingsapp/src/assets/colors.dart';
import 'package:bookingsapp/src/assets/fonts.dart';
import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/main.dart';
import 'package:bookingsapp/src/models/ammenity.dart';
import 'package:bookingsapp/src/models/event.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:bookingsapp/src/models/request.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:bookingsapp/src/screens/amenitySearch.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:bookingsapp/src/screens/userProfile.dart';
import 'package:bookingsapp/src/screens/webview.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class IndividualTab extends StatefulWidget {
  final User userlogged;

  IndividualTab(this.userlogged);

  @override
  _IndividualTabState createState() => _IndividualTabState();
}

class _IndividualTabState extends State<IndividualTab> {
  late Future<List<dynamic>> dataIndvFuture;

  @override
  void initState() {
    super.initState();
    setState(() {
      dataIndvFuture = getBookingsIndvidual(widget.userlogged.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Future<List<dynamic>> dataIndvFuture =
            getBookingsIndvidual(widget.userlogged.userId);
        setState(() {
          this.dataIndvFuture = dataIndvFuture;
        });
      },
      child: FutureBuilder<List<dynamic>>(
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
                "No Bookings Found",
                style: FontsCustom.bodyBigText,
              ),
            );
          } else {
            List<dynamic> dataIndv = snapshot.data ?? [];
            return ListView.builder(
              itemCount: dataIndv.length,
              itemBuilder: (context, index) {
                final item = dataIndv[index];
                bool opcode = item.runtimeType.toString() == "Event";

                String formattedDateTime = opcode
                    ? DateFormat.yMMMMd()
                        .add_jm()
                        .format(DateTime.parse(item.eventDate))
                    : DateFormat("MMMM dd h:mm a").format(DateTime.parse(
                        item.amenityDate + " " + item.amenitySlot));

                return ListTile(
                  leading: CircleAvatar(
                      backgroundColor: ColorSchemes.backgroundColor,
                      radius: 15.0,
                      child: ((opcode
                                  ? item.eventPicture
                                  : item.amenityPicture) ==
                              "")
                          ? const Icon(Icons.access_alarm,
                              size: 30, color: Colors.black)
                          : ClipOval(
                              child: Image.network(
                              opcode ? item.eventPicture : item.amenityPicture,
                              width: 30.0,
                              height: 30.0,
                              fit: BoxFit.cover,
                            ))),
                  title: Text(opcode ? item.eventName : item.amenityName),
                  trailing: Text(formattedDateTime),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class TeamTab extends ConsumerStatefulWidget {
  final User userlogged;

  TeamTab(this.userlogged);

  @override
  _TeamTabState createState() => _TeamTabState();
}

class _TeamTabState extends ConsumerState<TeamTab> {
  late Future<List<dynamic>> dataTeamFuture;
  List<String> teams = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      dataTeamFuture = getBookingsTeam(widget.userlogged.userId, ref);
      teams = ref.read(teamsList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Future<List<dynamic>> dataTeamFuture =
            getBookingsTeam(widget.userlogged.userId, ref);
        setState(() {
          this.dataTeamFuture = dataTeamFuture;
        });
      },
      child: FutureBuilder<List<dynamic>>(
        future: dataTeamFuture,
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
                "No Bookings Found",
                style: FontsCustom.bodyBigText,
              ),
            );
          } else {
            List<dynamic> dataTeam = snapshot.data ?? [];
            return ListView.builder(
              itemCount: dataTeam.length,
              itemBuilder: (context, index) {
                final item = dataTeam[index];
                bool opcode = item.runtimeType.toString() == "Event";

                DateTime inputDateTime =
                    DateTime.parse(opcode ? item.eventDate : item.amenityDate);

                String formattedDateTime =
                    DateFormat.yMMMMd().add_jm().format(inputDateTime);

                return ListTile(
                  leading: CircleAvatar(
                      backgroundColor: ColorSchemes.backgroundColor,
                      radius: 20.0,
                      child: ((opcode
                                  ? item.eventPicture
                                  : item.amenityPicture) ==
                              "")
                          ? const Icon(Icons.access_alarm,
                              size: 30, color: Colors.black)
                          : ClipOval(
                              child: Image.network(
                              opcode ? item.eventPicture : item.amenityPicture,
                              width: 30.0,
                              height: 30.0,
                              fit: BoxFit.cover,
                            ))),
                  title: Text(opcode ? item.eventName : item.amenityName),
                  subtitle: Text(teams[index]),
                  trailing: Text(formattedDateTime),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class RequestTab extends StatefulWidget {
  final User userlogged;

  RequestTab(this.userlogged);

  @override
  _RequestTabState createState() => _RequestTabState();
}

class _RequestTabState extends State<RequestTab> {
  late Future<List<Requests>> dataReq;

  @override
  void initState() {
    super.initState();
    setState(() {
      dataReq = getRequest(widget.userlogged.userId);
    });
  }

  void rebuild() {
    setState(() {
      dataReq = getRequest(widget.userlogged.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Future<List<Requests>> dataReq = getRequest(widget.userlogged.userId);
        setState(() {
          this.dataReq = dataReq;
        });
      },
      child: FutureBuilder<List<dynamic>>(
        future: dataReq,
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
                "No Bookings Found",
                style: FontsCustom.bodyBigText,
              ),
            );
          } else {
            // Data is available, build the ListView
            List<dynamic> dataTeam = snapshot.data ?? [];
            return ListView.builder(
              itemCount: dataTeam.length,
              itemBuilder: (context, index) {
                final item = dataTeam[index];
                bool opcode = item.runtimeType.toString() == "Event";

                String formattedDateTime = opcode
                    ? DateFormat.yMMMMd()
                        .add_jm()
                        .format(DateTime.parse(item.getDateTime()))
                    : DateFormat("MMMM dd, yyyy h:mm a")
                        .format(DateTime.parse(item.getDateTime()));

                return ListTile(
                  leading: CircleAvatar(
                      backgroundColor: ColorSchemes.backgroundColor,
                      radius: 20.0,
                      child: (item.getImage() == "")
                          ? const Icon(Icons.access_alarm,
                              size: 30, color: Colors.black)
                          : ClipOval(
                              child: Image.network(
                              item.getImage(),
                              width: 30.0,
                              height: 30.0,
                              fit: BoxFit.cover,
                            ))),
                  title: Text(item.getName()),
                  subtitle: Text(formattedDateTime),
                  trailing: IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .all<Color>(ColorSchemes
                                            .primaryColor), // Change this color to your desired background color
                                  ),
                                  onPressed: () async {
                                    await DatabaseQueries.deleteRequest(
                                        item.requestId);
                                    setState(() {
                                      rebuild();
                                    });

                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Confirm')),
                            );
                          });
                    },
                    color: ColorSchemes.primaryColor,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class TabWidget extends ConsumerStatefulWidget {
  User userlogged;

  TabWidget(this.userlogged);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TabWidgetState();
}

class _TabWidgetState extends ConsumerState<TabWidget>
    with TickerProviderStateMixin {
  late TabController tabController;
  void initState() {
    super.initState();
    setState(() {
      tabController = TabController(length: 3, vsync: this);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorSchemes.primaryColor,
            title: Text(
              "BOOKING\$",
              style: FontsCustom.heading,
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  tooltip: 'User Profile',
                  onPressed: () {
                    router.push("/userprofile/${ref.read(userLogged).userId}");
                  },
                  icon: Icon(Icons.person)),
            ],
            bottom: TabBar(
              controller: tabController,
              tabs: [
                Tab(text: 'Individual'),
                Tab(text: 'Team'),
                Tab(text: 'Requests')
              ],
              indicator: BoxDecoration(color: ColorSchemes.secondayColor),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [ColorSchemes.tertiaryColor, ColorSchemes.whiteColor],
              ),
            ),
            child: TabBarView(
              controller: tabController,
              children: [
                IndividualTab(widget.userlogged),
                TeamTab(widget.userlogged),
                RequestTab(widget.userlogged)
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
              color: ColorSchemes.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: IconButton(
                        tooltip: 'Home',
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
                        tooltip: 'Your Teams',
                        onPressed: () {
                          context.go("/team");
                        },
                        icon: Icon(
                          Icons.people,
                          color: ColorSchemes.backgroundColor,
                        )),
                  ),
                  Expanded(
                    child: IconButton(
                        tooltip: 'Logout',
                        onPressed: () async {
                          final storage = new FlutterSecureStorage();
                          await storage.deleteAll();
                          context.go("/login");
                        },
                        icon: Icon(
                          Icons.logout,
                          color: ColorSchemes.backgroundColor,
                        )),
                  )
                ],
              )),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Book an Amenity',
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AmenityAlertBox();
                  });
            },
            child: Icon(Icons.add),
            backgroundColor: ColorSchemes.blendColor,
          )),
    ));
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<dynamic> dataIndv = [];
  Map dataTeam = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User userlogged = ref.read(userLogged);

    return TabWidget(userlogged);
  }
}
