import 'package:bookingsapp/src/models/event.dart';
import 'package:bookingsapp/src/models/team.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class EventsBooked extends StatefulWidget {
  List<Event> events;
  Team team;
  EventsBooked(this.events, this.team, {super.key});

  @override
  State<EventsBooked> createState() => _EventsBookedState();
}

class _EventsBookedState extends State<EventsBooked> {
  @override
  Widget build(BuildContext context) {
    final eventsReversed = widget.events.reversed.toList();
    return eventsReversed.isEmpty
        ? Center(
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
                  "No Booked Events Found",
                  style: Theme.of(context).textTheme.bodyLarge!,
                ),
              ],
            ),
          )
        : ListView.builder(
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
