import 'package:bookingsapp/src/database/dbEvent.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventTab extends StatefulWidget {
  final User userlogged;
  const EventTab(this.userlogged, {super.key});

  @override
  State<EventTab> createState() => _EventTabState();
}

class _EventTabState extends State<EventTab> {
  late Future<List<dynamic>> _dataIndvFuture;
  @override
  void initState() {
    super.initState();
    setState(() {
      _dataIndvFuture = getEventUser(widget.userlogged.userId);
    });
  }

  void rebuild() {
    setState(() {
      _dataIndvFuture = getEventUser(widget.userlogged.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _dataIndvFuture,
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
                  "No Event Found",
                  style: Theme.of(context).textTheme.bodyLarge!,
                ),
              ],
            ),
          );
        } else {
          List<dynamic> dataIndv = snapshot.data ?? [];
          dataIndv = dataIndv.reversed.toList();
          return ListView.builder(
            itemCount: dataIndv.length,
            itemBuilder: (context, index) {
              final item = dataIndv[index];
              DateTime inputDateTime = DateTime.parse(item.eventDate);

              String formattedDateTime =
                  DateFormat.yMMMMd().add_jm().format(inputDateTime);
              return ListTile(
                leading: CircleAvatar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete_forever_sharp,
                    color: Colors.red,
                  ),
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
                                  'Are you sure you want to delete this event?'),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      await DatabaseQueriesEvent.deleteEvent(
                                          item.eventId);

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
                ),
              );
            },
          );
        }
      },
    );
  }
}
