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
  List<Request> requests = [];
  bool isLoading = true;
  Future<void> setData() async {
    List<dynamic> reponse =
        (await DatabaseQueries.getRequest(ref.read(userLogged).userId)).data;
    for (var requestindv in reponse) {
      Request request = Request.defaultRequest();
      await request.setData(requestindv);
      setState(() {
        requests.add(request);
      });
    }
    setState(() {
      isLoading = false;
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
        backgroundColor: ColorCustomScheme.appBarColor,
        title: Text(
          "BOOKING\$",
          style: FontsCustom.heading,
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];

                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      await DatabaseQueries.deleteRequest(request.requestId);
                      setState(() {
                        requests.removeAt(index);
                      });
                    } else if (direction == DismissDirection.startToEnd) {
                      await DatabaseQueries.requestToBooking(request.requestId);
                      setState(() {
                        requests.removeAt(index);
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
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(request.getName()),
                      subtitle: Text(request.getDateTime()),
                      trailing: Text("NO OF BOOKINGS : ${request.capacity}"),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
          color: ColorCustomScheme.appBarColor,
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
                      color: ColorCustomScheme.backgroundColor,
                    )),
              ),
              Expanded(
                child: IconButton(
                    onPressed: () {
                      router.push("/eventAdmin");
                    },
                    icon: Icon(
                      Icons.event,
                      color: ColorCustomScheme.backgroundColor,
                    )),
              ),
              Expanded(
                child: IconButton(
                    onPressed: () {
                      router.push("/amenityAdmin");
                    },
                    icon: Icon(
                      Icons.local_activity,
                      color: ColorCustomScheme.backgroundColor,
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
                      color: ColorCustomScheme.backgroundColor,
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
                      color: ColorCustomScheme.backgroundColor,
                    )),
              )
            ],
          )),
    );
  }
}
