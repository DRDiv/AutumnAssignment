import 'package:bookingsapp/functions/get.dart';
import 'package:bookingsapp/src/assets/colors.dart';
import 'package:bookingsapp/src/assets/fonts.dart';
import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/src/models/ammenity.dart';
import 'package:bookingsapp/src/models/event.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AmenityTab extends StatefulWidget {
  final User userlogged;
  const AmenityTab(this.userlogged);

  @override
  State<AmenityTab> createState() => _AmenityTabState();
}

class _AmenityTabState extends State<AmenityTab> {
  late Future<List<dynamic>> dataIndvFuture;
  void initState() {
    super.initState();
    setState(() {
      dataIndvFuture = getAmmenityUser();
    });
  }

  Future<List<dynamic>> getAmmenityUser() async {
    try {
      var amenityUser =
          await DatabaseQueries.getAmmenityUser(widget.userlogged.userId);

      if (amenityUser.statusCode == 200) {
        List<dynamic> responseData = amenityUser.data;

        List<dynamic> typedData = [];

        for (var responseInd in amenityUser.data) {
          var responseAmenity = await DatabaseQueries.getAmmenityDetails(
              responseInd['amenityId']);

          Amenity amenity = Amenity.defaultAmenity();

          await amenity.setData(responseAmenity.data, "", "");
          typedData.add(amenity);
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
              "No Amenity Found",
              style: FontsCustom.bodyBigText,
            ),
          );
        } else {
          List<dynamic> dataIndv = snapshot.data ?? [];
          return ListView.builder(
            itemCount: dataIndv.length,
            itemBuilder: (context, index) {
              final item = dataIndv[index];

              return ListTile(
                leading: CircleAvatar(
                    backgroundColor: ColorSchemes.backgroundColor,
                    radius: 15.0,
                    child: ((item.amenityPicture) == "")
                        ? const Icon(Icons.access_alarm,
                            size: 30, color: Colors.black)
                        : ClipOval(
                            child: Image.network(
                            item.amenityPicture,
                            width: 30.0,
                            height: 30.0,
                            fit: BoxFit.cover,
                          ))),
                title: Text(item.amenityName),
              );
            },
          );
        }
      },
    );
    ;
  }
}

class EventTab extends StatefulWidget {
  final User userlogged;
  const EventTab(this.userlogged);

  @override
  State<EventTab> createState() => _EventTabState();
}

class _EventTabState extends State<EventTab> {
  late Future<List<dynamic>> dataIndvFuture;
  void initState() {
    super.initState();
    setState(() {
      dataIndvFuture = getAmmenityUser(widget.userlogged.userId);
    });
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
              "No Amenity Found",
              style: FontsCustom.bodyBigText,
            ),
          );
        } else {
          List<dynamic> dataIndv = snapshot.data ?? [];
          return ListView.builder(
            itemCount: dataIndv.length,
            itemBuilder: (context, index) {
              final item = dataIndv[index];
              DateTime inputDateTime = DateTime.parse(item.eventDate);

              String formattedDateTime =
                  DateFormat.yMMMMd().add_jm().format(inputDateTime);
              return ListTile(
                leading: CircleAvatar(
                    backgroundColor: ColorSchemes.backgroundColor,
                    radius: 15.0,
                    child: ((item.eventPicture) == "")
                        ? const Icon(Icons.access_alarm,
                            size: 30, color: Colors.black)
                        : ClipOval(
                            child: Image.network(
                            item.eventPicture,
                            width: 30.0,
                            height: 30.0,
                            fit: BoxFit.cover,
                          ))),
                title: Text(item.eventName),
                subtitle: Text(formattedDateTime),
              );
            },
          );
        }
      },
    );
    ;
  }
}

class TabWidget extends ConsumerStatefulWidget {
  User userlogged;

  TabWidget(this.userlogged);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TabWidgetState();
}

class _TabWidgetState extends ConsumerState<TabWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorSchemes.primaryColor,
            title: Text(
              "BOOKING\$",
              style: FontsCustom.heading,
            ),
            centerTitle: true,
            bottom: TabBar(
              tabs: [Tab(text: 'Amenity'), Tab(text: 'Event')],
              indicator: BoxDecoration(color: ColorSchemes.secondayColor),
            ),
          ),
          body: TabBarView(
            children: [
              AmenityTab(widget.userlogged),
              EventTab(widget.userlogged),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
              color: ColorSchemes.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: IconButton(
                        onPressed: () {
                          context.go("/homeAdmin");
                        },
                        icon: Icon(
                          Icons.home,
                          color: ColorSchemes.backgroundColor,
                        )),
                  ),
                  Expanded(
                    child: IconButton(
                        onPressed: () {
                          router.push("/eventAdmin");
                        },
                        icon: Icon(
                          Icons.event,
                          color: ColorSchemes.backgroundColor,
                        )),
                  ),
                  Expanded(
                    child: IconButton(
                        onPressed: () {
                          router.push("/amenityAdmin");
                        },
                        icon: Icon(
                          Icons.local_activity,
                          color: ColorSchemes.backgroundColor,
                        )),
                  ),
                  Expanded(
                    child: IconButton(
                        onPressed: () async {
                          final storage = new FlutterSecureStorage();
                          await storage.deleteAll();
                          context.go("/adminManage");
                        },
                        icon: Icon(
                          Icons.admin_panel_settings,
                          color: ColorSchemes.backgroundColor,
                        )),
                  ),
                  Expanded(
                    child: IconButton(
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
        ),
      ),
    );
  }
}

class AdminManage extends ConsumerStatefulWidget {
  const AdminManage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminManageState();
}

class _AdminManageState extends ConsumerState<AdminManage> {
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
