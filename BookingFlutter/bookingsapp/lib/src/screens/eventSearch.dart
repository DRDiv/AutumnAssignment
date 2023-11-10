import 'package:bookingsapp/src/assets/colors.dart';
import 'package:bookingsapp/src/assets/fonts.dart';
import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/src/models/event.dart';
import 'package:bookingsapp/src/models/team.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EventAlertBox extends ConsumerStatefulWidget {
  Team team;
  EventAlertBox(this.team);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventAlertBoxState();
}

class _EventAlertBoxState extends ConsumerState<EventAlertBox> {
  TextEditingController _text = TextEditingController();
  String like = '';
  Future<List<Event>> getEvents(String like) async {
    var response = await DatabaseQueries.getEventRegex(like);
    List<Event> events = [];

    for (var indv in response.data) {
      Event eventInd = Event.defaultEvent();
      await eventInd.setData(indv);

      events.add(eventInd);
    }
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: SizedBox(
          height: 400,
          width: 200,
          child: Column(
            children: [
              Container(
                color: ColorSchemes.backgroundColor,
                child: TextFormField(
                  onChanged: (text) {
                    setState(() {
                      like = text;
                    });
                  },
                  controller: _text,
                  decoration: InputDecoration(
                    hintText: 'Search Event',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorSchemes.primaryColor),
                    ),
                  ),
                  cursorColor: ColorSchemes.primaryColor,
                ),
              ),
              FutureBuilder<List<Event>>(
                future: getEvents(like),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(8, 40, 8, 0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(8, 40, 8, 0),
                      child: Center(
                        child: Text(
                          "No Events Found",
                          style: FontsCustom.bodyBigText,
                        ),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () async {
                              Navigator.of(context).pop();
                              router.push(
                                  "/eventBooking/${snapshot.data![index].eventId}/${widget.team.teamId}/");
                            },
                            leading: CircleAvatar(
                                backgroundColor: ColorSchemes.backgroundColor,
                                radius: 15.0,
                                child:
                                    (snapshot.data![index].eventPicture == "")
                                        ? const Icon(Icons.alarm,
                                            size: 30, color: Colors.black)
                                        : ClipOval(
                                            child: Image.network(
                                            snapshot.data![index].eventPicture,
                                            width: 30.0,
                                            height: 30.0,
                                            fit: BoxFit.cover,
                                          ))),
                            title: Text(snapshot.data![index].eventName),
                            subtitle: Text(DateFormat.yMMMMd('en_US')
                                .add_Hm()
                                .format(DateTime.parse(
                                    snapshot.data![index].eventDate))),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
