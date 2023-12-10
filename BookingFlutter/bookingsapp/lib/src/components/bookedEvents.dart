import 'package:bookingsapp/src/models/event.dart';
import 'package:bookingsapp/src/models/team.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsBooked extends StatefulWidget {
  List<Event> events;
  Team team;
  EventsBooked(this.events, this.team);

  @override
  State<EventsBooked> createState() => _EventsBookedState();
}

class _EventsBookedState extends State<EventsBooked> {
  @override
  Widget build(BuildContext context) {
    final eventsReversed = widget.events.reversed.toList();
    return ListView.builder(
        itemCount: eventsReversed.length,
        itemBuilder: (context, index) {
          final eventInd = eventsReversed[index];
          DateTime inputDateTime = DateTime.parse(eventInd.eventDate);

          String formattedDateTime =
              DateFormat.yMMMMd().add_jm().format(inputDateTime);
          return ListTile(
            leading: (eventInd.eventPicture == "")
                ? const Icon(Icons.alarm, size: 30, color: Colors.black)
                : ClipOval(
                    child: Image.network(
                    eventInd.eventPicture,
                    width: 30.0,
                    height: 30.0,
                    fit: BoxFit.cover,
                  )),
            title: Text(eventInd.eventName),
            trailing: Text(formattedDateTime),
          );
        });
  }
}
