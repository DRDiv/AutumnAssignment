import 'package:bookingsapp/src/database/dbRequest.dart';
import 'package:bookingsapp/src/models/request.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RequestTab extends StatefulWidget {
  final User userlogged;

  const RequestTab(this.userlogged, {super.key});

  @override
  _RequestTabState createState() => _RequestTabState();
}

class _RequestTabState extends State<RequestTab> {
  late Future<List<Requests>> _dataReq;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dataReq = getRequest(widget.userlogged.userId);
    });
  }

  void rebuild() {
    setState(() {
      _dataReq = getRequest(widget.userlogged.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Future<List<Requests>> dataReq = getRequest(widget.userlogged.userId);
        setState(() {
          _dataReq = dataReq;
        });
      },
      child: FutureBuilder<List<dynamic>>(
        future: _dataReq,
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
                    size: 50,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "No Requests Found",
                    style: Theme.of(context).textTheme.bodyLarge!,
                  ),
                ],
              ),
            );
          } else {
            List<dynamic> dataTeam = snapshot.data ?? [];
            dataTeam = dataTeam.reversed.toList();
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
                            title: const Text('Confirmation'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                    'Are you sure you want to delete this request?'),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        await DatabaseQueriesRequest
                                            .deleteRequest(item.requestId);
                                        setState(() {
                                          rebuild();
                                        });
                                        router.pop();
                                      },
                                      child: const Text('Confirm'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
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
