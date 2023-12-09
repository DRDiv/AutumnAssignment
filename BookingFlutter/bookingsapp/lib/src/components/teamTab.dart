import 'package:bookingsapp/src/assets/colors.dart';
import 'package:bookingsapp/src/assets/fonts.dart';
import 'package:bookingsapp/src/functions/get.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TeamTab extends ConsumerStatefulWidget {
  final User userlogged;

  TeamTab(this.userlogged);

  @override
  _TeamTabState createState() => _TeamTabState();
}

class _TeamTabState extends ConsumerState<TeamTab> {
  late Future<List<dynamic>> _dataTeamFuture;
  List<String> teams = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _dataTeamFuture = getBookingsTeam(widget.userlogged.userId, ref);
      teams = ref.read(teamsList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Future<List<dynamic>> dataTeamFuture =
            getBookingsTeam(widget.userlogged.userId, ref);
        setState(() {
          this._dataTeamFuture = dataTeamFuture;
        });
      },
      child: FutureBuilder<List<dynamic>>(
        future: _dataTeamFuture,
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
                      backgroundColor: ColorSchemes.backgroundColor,
                      radius: 20.0,
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
                  subtitle: Text(teams[index]),
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
