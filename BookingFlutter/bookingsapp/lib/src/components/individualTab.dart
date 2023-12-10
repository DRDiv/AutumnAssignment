import 'package:bookingsapp/src/functions/get.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IndividualTab extends StatefulWidget {
  final User userlogged;

  IndividualTab(this.userlogged);

  @override
  _IndividualTabState createState() => _IndividualTabState();
}

class _IndividualTabState extends State<IndividualTab> {
  late Future<List<dynamic>> _dataIndvFuture;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dataIndvFuture = getBookingsIndvidual(widget.userlogged.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Future<List<dynamic>> dataIndvFuture =
            getBookingsIndvidual(widget.userlogged.userId);
        setState(() {
          this._dataIndvFuture = dataIndvFuture;
        });
      },
      child: FutureBuilder<List<dynamic>>(
        future: _dataIndvFuture,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning,
                    size: 50, // Adjust the size of the icon as needed
                    color: Colors.red, // Adjust the color of the icon as needed
                  ),
                  SizedBox(
                      height:
                          10), // Add some spacing between the icon and the text
                  Text(
                    "No Bookings Found",
                    style: Theme.of(context).textTheme.bodyLarge!,
                  ),
                ],
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
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
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
