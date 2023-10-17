import 'package:bookingsapp/assets/colors.dart';
import 'package:bookingsapp/assets/fonts.dart';
import 'package:bookingsapp/database/database.dart';
import 'package:bookingsapp/main.dart';
import 'package:bookingsapp/models/ammenity.dart';
import 'package:bookingsapp/models/event.dart';
import 'package:bookingsapp/models/user.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:bookingsapp/src/screens/webview.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class IndividualTab extends StatefulWidget {
  final String ipAdd;
  final User userlogged;

  IndividualTab(this.userlogged, this.ipAdd);

  @override
  _IndividualTabState createState() => _IndividualTabState();
}

class _IndividualTabState extends State<IndividualTab> {
  late Future<List<dynamic>> dataIndvFuture;

  @override
  void initState() {
    super.initState();
    setState(() {
      dataIndvFuture = getBookingsIndvidual();
    });
  }

  Future<List<dynamic>> getBookingsIndvidual() async {
    try {
      var bookingUser =
          await DatabaseQueries.getBookingsUser(widget.userlogged.userId);

      if (bookingUser.statusCode == 200) {
        List<dynamic> responseData = bookingUser.data;

        List<dynamic> typedData = [];

        for (var responseInd in bookingUser.data) {
          if (responseInd['amenity'] != null) {
            var responseAmenity = await DatabaseQueries.getAmmenityDetails(
                responseInd['amenity']);
            Amenity amenity = Amenity.defaultAmenity();
            await amenity.setData(responseAmenity.data);
            typedData.add(amenity);
          }
          if (responseInd['event'] != null) {
            var responseEvent =
                await DatabaseQueries.getEventDetails(responseInd['event']);
            Event event = Event.defaultEvent();

            await event.setData(responseEvent.data);
            typedData.add(event);
          }
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
    return FutureBuilder<List<dynamic>>(
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
          // Data is available, build the ListView
          List<dynamic> dataIndv = snapshot.data ?? [];
          return ListView.builder(
            itemCount: dataIndv.length,
            itemBuilder: (context, index) {
              final item = dataIndv[index];
              bool opcode = item.runtimeType.toString() == "Event";

              DateTime inputDateTime =
                  DateTime.parse(opcode ? item.eventDate : item.amenityDate);

              String formattedDateTime =
                  DateFormat.yMMMMd().add_jm().format(inputDateTime);

              return ListTile(
                leading: CircleAvatar(
                    backgroundColor: ColorCustomScheme.backgroundColor,
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
    );
  }
}

class TeamTab extends StatefulWidget {
  final User userlogged;

  final String ipAdd;

  TeamTab(this.userlogged, this.ipAdd);

  @override
  _TeamTabState createState() => _TeamTabState();
}

class _TeamTabState extends State<TeamTab> {
  late Future<List<dynamic>> dataTeamFuture;

  @override
  void initState() {
    super.initState();
    setState(() {
      dataTeamFuture = getBookingsTeam();
    });
  }

  Future<List<dynamic>> getBookingsTeam() async {
    try {
      var bookingUser =
          await DatabaseQueries.getBookingsTeam(widget.userlogged.userId);

      if (bookingUser.statusCode == 200) {
        List<dynamic> responseData = bookingUser.data;

        List<dynamic> typedData = [];

        for (var responseInd in bookingUser.data) {
          if (responseInd['amenity'] != null) {
            var responseAmenity = await DatabaseQueries.getAmmenityDetails(
                responseInd['amenity']);
            Amenity amenity = Amenity.defaultAmenity();
            await amenity.setData(responseAmenity.data);
            typedData.add(amenity);
          }
          if (responseInd['event'] != null) {
            var responseEvent =
                await DatabaseQueries.getEventDetails(responseInd['event']);
            Event event = Event.defaultEvent();

            await event.setData(responseEvent.data);
            typedData.add(event);
          }
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
    return FutureBuilder<List<dynamic>>(
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
          // Data is available, build the ListView
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
                    backgroundColor: ColorCustomScheme.backgroundColor,
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
    );
  }
}

class TabWidget extends StatelessWidget {
  User userlogged;
  String ipAdd;

  TabWidget(this.userlogged, this.ipAdd);
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
            tabs: [Tab(text: 'Individual/Group'), Tab(text: 'Team')],
            indicator:
                BoxDecoration(color: ColorCustomScheme.appBarColorSelected),
          ),
        ),
        body: TabBarView(
          children: [
            IndividualTab(userlogged, ipAdd),
            TeamTab(userlogged, ipAdd)
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

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<dynamic> dataIndv = [];
  Map dataTeam = {};
  bool isLoading = true;

  Future<void> getBookingsTeam() async {
    User userlogged = ref.read(userLogged);
    String ipAdd = ref.read(ip);
    var dio = Dio();
    // try {
    //   var response = await dio.get('$ipAdd/booking/team/$userIdValue/');
    //   if (response.statusCode == 200) {
    //     dataTeam = response.data;
    //   }
    // } catch (e) {
    //   dataTeam = {};
    // }
    dataTeam = {};
  }

  @override
  void initState() {
    super.initState();

    getBookingsTeam();
  }

  @override
  Widget build(BuildContext context) {
    User userlogged = ref.read(userLogged);
    String ipAdd = ref.read(ip);
    return TabWidget(userlogged, ipAdd);
  }
}
