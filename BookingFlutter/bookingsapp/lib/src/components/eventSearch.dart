import 'package:bookingsapp/src/functions/get.dart';
import 'package:bookingsapp/src/assets/colors.dart';
import 'package:bookingsapp/src/assets/fonts.dart';
import 'package:bookingsapp/src/models/event.dart';
import 'package:bookingsapp/src/models/team.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:bookingsapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class EventAlertBox extends ConsumerStatefulWidget {
  Team team;
  EventAlertBox(this.team, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventAlertBoxState();
}

class _EventAlertBoxState extends ConsumerState<EventAlertBox> {
  final TextEditingController _text = TextEditingController();
  String _like = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Theme(
          data: AppTheme.lightTheme(),
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
                        _like = text;
                      });
                    },
                    controller: _text,
                    decoration: const InputDecoration(
                      hintText: 'Search Event',
                      prefixIcon: Icon(Icons.search),
                    ),
                    cursorColor: ColorSchemes.primaryColor,
                  ),
                ),
                FutureBuilder<List<Event>>(
                  future: getEvents(_like),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.fromLTRB(8, 40, 8, 0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 60,
                            ),
                            const Icon(
                              Icons.warning,
                              size: 50, // Adjust the size of the icon as needed
                              color: Colors
                                  .red, // Adjust the color of the icon as needed
                            ),
                            const SizedBox(
                                height:
                                    10), // Add some spacing between the icon and the text
                            Text(
                              "No Event Found",
                              style: FontsCustom.bodyBigText,
                            ),
                          ],
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
                                  child: (snapshot.data![index].eventPicture ==
                                          "")
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
      ),
    );
  }
}
