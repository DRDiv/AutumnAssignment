import 'package:bookingsapp/src/database/dbEvent.dart';
import 'package:bookingsapp/src/models/user.dart';
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
            child: Text(
              "No Amenity Found",
              style: Theme.of(context).textTheme.bodyLarge!,
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
              );
            },
          );
        }
      },
    );
  }
}
