import 'dart:convert';
import 'dart:io';

import 'package:bookingsapp/src/assets/colors.dart';
import 'package:bookingsapp/src/assets/fonts.dart';
import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/src/models/event.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class EventBooking extends ConsumerStatefulWidget {
  final String eventId;
  final String teamId;
  const EventBooking(this.eventId, this.teamId);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventBookingState();
}

class _EventBookingState extends ConsumerState<EventBooking> {
  Event event = Event.defaultEvent();
  bool isLoading = true;
  File? image;
  Future<void> setData() async {
    Event e = Event.defaultEvent();
    await e
        .setData((await DatabaseQueries.getEventDetails(widget.eventId)).data);
    setState(() {
      event = e;
      isLoading = false;
    });
  }

  void initState() {
    super.initState();
    setData();
  }

  Future<void> _getImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorCustomScheme.appBarColor,
        title: Text(
          "BOOKING\$",
          style: FontsCustom.heading,
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 24, 8, 0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Center(
                          child: Container(
                            height: 200,
                            width: 300,
                            decoration: BoxDecoration(
                              color: ColorCustomScheme.backgroundColor,
                            ),
                            child: (event.eventPicture == "")
                                ? Icon(
                                    Icons.category_sharp,
                                    size: 100,
                                  )
                                : ClipRRect(
                                    child: Image.network(
                                    event.eventPicture,
                                    fit: BoxFit.fitHeight,
                                  )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            event.eventName,
                            style: FontsCustom.bodyHeading,
                          ),
                        ),
                        (event.payment > 0)
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Attach Payment:",
                                      style: FontsCustom.bodySmallText,
                                    ),
                                    ElevatedButton(
                                        onPressed: _getImage,
                                        child:
                                            Text("Insert Payment Screenshot"))
                                  ],
                                ),
                              )
                            : Row(),
                      ],
                    ),
                    SizedBox(height: 100),
                    ElevatedButton(
                        onPressed: () async {
                          if (event.payment > 0 && image == null) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: SizedBox(
                                    height: 75,
                                    width: 100,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          'Attach Payment',
                                          style: FontsCustom.bodyBigText,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              router.pop();
                                            },
                                            child: Text("OK"))
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            return;
                          }

                          dynamic response =
                              await DatabaseQueries.makeEventRequest(
                                  widget.eventId, widget.teamId, image);

                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: SizedBox(
                                  height: 75,
                                  width: 100,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        json.decode(
                                            response.toString())['message'],
                                        style: FontsCustom.bodyBigText,
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            router.pop();
                                          },
                                          child: Text("OK"))
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Text("Send Request"))
                  ],
                ),
              ),
            ),
    );
  }
}
