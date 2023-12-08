import 'package:bookingsapp/src/assets/colors.dart';
import 'package:bookingsapp/src/assets/fonts.dart';
import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/src/models/request.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class HomeAdmin extends ConsumerStatefulWidget {
  const HomeAdmin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeAdminState();
}

class _HomeAdminState extends ConsumerState<HomeAdmin> {
  List<Requests> _requests = [];
  bool _isLoading = true;
  Future<void> setData() async {
    List<dynamic> reponse =
        (await DatabaseQueries.getRequest(ref.read(userLogged).userId)).data;
    for (var requestindv in reponse) {
      Requests request = Requests.defaultRequest();
      await request.setData(requestindv);
      setState(() {
        _requests.add(request);
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void initState() {
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSchemes.primaryColor,
        title: Text(
          "BOOKING\$",
          style: FontsCustom.heading,
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _isLoading = true;
            _requests.clear();
          });

          await setData();
        },
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ((_requests.length == 0)
                ? Center(
                    child: Text(
                    "No Aprrovals Pending!!",
                    style: FontsCustom.bodyBigText,
                  ))
                : ListView.builder(
                    itemCount: _requests.length,
                    itemBuilder: (context, index) {
                      final request = _requests[index];

                      return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            await DatabaseQueries.deleteRequest(
                                request.requestId);
                            setState(() {
                              _requests.removeAt(index);
                            });
                          } else if (direction == DismissDirection.startToEnd) {
                            await DatabaseQueries.requestToBooking(
                                request.requestId);
                            setState(() {
                              _requests.removeAt(index);
                            });
                          }
                        },
                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 16.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        background: Container(
                          color: Colors.green,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 16.0),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () {
                              if (request.payment != "") {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Center(
                                            child:
                                                Image.network(request.payment)),
                                      );
                                    });
                              }
                            },
                            title: Text(request.getName()),
                            subtitle: Text(request.getDateTime()),
                            trailing:
                                Text("NO OF BOOKINGS : ${request.capacity}"),
                          ),
                        ),
                      );
                    },
                  )),
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
                    icon: Column(
                      children: [
                        Icon(
                          Icons.home,
                          color: ColorSchemes.whiteColor,
                        ),
                        Text(
                          'Home',
                          style: FontsCustom.smallText,
                        ),
                      ],
                    )),
              ),
              Expanded(
                child: IconButton(
                    onPressed: () {
                      router.push("/eventAdmin");
                    },
                    icon: Column(
                      children: [
                        Icon(
                          Icons.event,
                          color: ColorSchemes.whiteColor,
                        ),
                        Text(
                          'Event',
                          style: FontsCustom.smallText,
                        ),
                      ],
                    )),
              ),
              Expanded(
                child: IconButton(
                    onPressed: () {
                      router.push("/amenityAdmin");
                    },
                    icon: Column(
                      children: [
                        Icon(
                          Icons.local_activity,
                          color: ColorSchemes.whiteColor,
                        ),
                        Text(
                          'Amenity',
                          style: FontsCustom.smallText,
                        ),
                      ],
                    )),
              ),
              Expanded(
                child: IconButton(
                    onPressed: () async {
                      final storage = new FlutterSecureStorage();
                      await storage.deleteAll();
                      context.go("/adminManage");
                    },
                    icon: Column(
                      children: [
                        Icon(
                          Icons.admin_panel_settings,
                          color: ColorSchemes.whiteColor,
                        ),
                        Text(
                          'Manage',
                          style: FontsCustom.smallText,
                        ),
                      ],
                    )),
              ),
              Expanded(
                child: IconButton(
                    onPressed: () async {
                      final storage = new FlutterSecureStorage();
                      await storage.deleteAll();
                      context.go("/login");
                    },
                    icon: Column(
                      children: [
                        Icon(
                          Icons.logout,
                          color: ColorSchemes.whiteColor,
                        ),
                        Text(
                          'Logout',
                          style: FontsCustom.smallText,
                        ),
                      ],
                    )),
              )
            ],
          )),
    );
  }
}
