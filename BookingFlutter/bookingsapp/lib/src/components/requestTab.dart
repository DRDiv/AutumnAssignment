import 'package:bookingsapp/src/assets/colors.dart';
import 'package:bookingsapp/src/assets/fonts.dart';
import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/src/functions/get.dart';
import 'package:bookingsapp/src/models/request.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
