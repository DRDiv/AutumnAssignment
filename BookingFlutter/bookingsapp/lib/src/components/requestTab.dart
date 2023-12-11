import 'package:bookingsapp/src/database/dbRequest.dart';
import 'package:bookingsapp/src/functions/format.dart';
import 'package:bookingsapp/src/models/request.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RequestTab extends StatefulWidget {
  final User userlogged;

  const RequestTab(this.userlogged, {super.key});

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
                    size: 50, // Adjust the size of the icon as needed
                    color: Colors.red, // Adjust the color of the icon as needed
                  ),
                  const SizedBox(
                      height:
                          10), // Add some spacing between the icon and the text
                  Text(
                    "No Requests Found",
                    style: Theme.of(context).textTheme.bodyLarge!,
                  ),
                ],
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
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
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
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: ElevatedButton(
                                  onPressed: () async {
                                    await DatabaseQueriesRequest.deleteRequest(
                                        item.requestId);
                                    setState(() {
                                      rebuild();
                                    });

                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Confirm')),
                            );
                          });
                    },
                    color: Theme.of(context).primaryColor,
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
