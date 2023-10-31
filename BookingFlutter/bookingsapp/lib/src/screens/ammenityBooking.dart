import 'dart:convert';
import 'dart:io';

import 'package:bookingsapp/src/assets/colors.dart';
import 'package:bookingsapp/src/assets/fonts.dart';
import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/src/models/ammenity.dart';

import 'package:bookingsapp/src/routing/routing.dart';
import 'package:bookingsapp/src/screens/groupMembers.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class DateSelector extends StatefulWidget {
  @override
  final String recurance;
  final void Function(DateTime) onDateSelected;

  DateSelector(this.recurance, this.onDateSelected);
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  String recurance = '';
  List<DateTime> dates = [];

  int selectedIndex = 0;
  void initState() {
    super.initState();
    print(widget.recurance);
    if (widget.recurance == "Daily") {
      setState(() {
        dates = List.generate(30, (index) {
          return DateTime.now().add(Duration(days: index));
        });
      });
    } else if (widget.recurance == "Weekly") {
      setState(() {
        dates = List.generate(15, (index) {
          return DateTime.now().add(Duration(days: index * 7));
        });
      });
    } else if (widget.recurance == "Monthly") {
      setState(() {
        dates = List.generate(3, (index) {
          return DateTime.now().add(Duration(days: index * 30));
        });
      });
    } else if (widget.recurance == "Yearly") {
      setState(() {
        dates = List.generate(1, (index) {
          return DateTime.now().add(Duration(days: index * 365));
        });
      });
    } else if (widget.recurance == "Onetime") {
      setState(() {
        dates = List.generate(1, (index) {
          return DateTime.now().add(Duration(days: index));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Date Selector',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: ColorCustomScheme.appBarColor, // Custom color
      ),
      body: Center(
        child: Container(
          height: 100.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                    widget.onDateSelected(dates[index]);
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? ColorCustomScheme.appBarColorSelected // Custom color
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '${dates[index].day}/${dates[index].month}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class TimeSelector extends StatefulWidget {
  final List<String> options;
  final void Function(String) onTimeSelected;

  TimeSelector(this.options, this.onTimeSelected);

  @override
  _TimeSelectorState createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Time Selector',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: ColorCustomScheme.appBarColor, // Custom color
      ),
      body: Center(
        child: Container(
          height: 100.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount:
                widget.options.length, // Use the provided list of options
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                    widget.onTimeSelected(widget.options[
                        index]); // Call the callback with the selected time
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? ColorCustomScheme.appBarColorSelected // Custom color
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.options[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class AmenityBooking extends ConsumerStatefulWidget {
  final String amenityId;

  AmenityBooking(this.amenityId);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AmenityBookingState();
}

String formatTimeRange(String startTime, String endTime) {
  final start = DateTime.parse('2023-10-21T$startTime');
  final end = DateTime.parse('2023-10-21T$endTime');

  final formattedStart = start.hour > 12
      ? '${start.hour - 12}:${start.minute.toString().padLeft(2, '0')} PM'
      : '${start.hour}:${start.minute.toString().padLeft(2, '0')} AM';
  final formattedEnd = end.hour > 12
      ? '${end.hour - 12}:${end.minute.toString().padLeft(2, '0')} PM'
      : '${end.hour}:${end.minute.toString().padLeft(2, '0')} AM';

  return '$formattedStart - $formattedEnd';
}

DateTime parseStartTime(String formattedTimeRange) {
  // Split the formatted time range into start and end times
  final parts = formattedTimeRange.split(' - ');

  if (parts.length == 2) {
    final startTime = parts[0];
    final isPM = startTime.endsWith('PM');
    final timeWithoutAMPM =
        startTime.replaceAll('AM', '').replaceAll('PM', '').trim();
    final timeParts = timeWithoutAMPM.split(':');

    if (timeParts.length == 2) {
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      if (isPM && hour < 12) {
        hour += 12;
      }

      return DateTime(2023, 10, 21, hour, minute);
    }
  }

  // Return null if parsing fails
  return DateTime.now();
}

class _AmenityBookingState extends ConsumerState<AmenityBooking> {
  Amenity amenity = Amenity.defaultAmenity();
  List<String> slots = [];
  List<String> users = [];
  bool isLoading = true;
  File? image;
  DateTime selectedDate = DateTime.now();
  String selectedTime = '';
  Future<void> setData() async {
    Amenity a = Amenity.defaultAmenity();
    await a.setData(
        (await DatabaseQueries.getAmmenityDetails(widget.amenityId)).data,
        "",
        "");
    var response = await DatabaseQueries.getAmmenitySlot(a.amenityId);
    print(response.data);
    setState(() {
      users.add(ref.read(userLogged).userId);
      for (var indv in response.data) {
        slots.add(
            formatTimeRange(indv['amenitySlotStart'], indv['amenitySlotEnd']));
      }
      amenity = a;

      selectedTime = slots[0];
      isLoading = false;
    });
  }

  void initState() {
    super.initState();
    setData();
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
                            child: (amenity.amenityPicture == "")
                                ? Icon(
                                    Icons.category_sharp,
                                    size: 100,
                                  )
                                : ClipRRect(
                                    child: Image.network(
                                    amenity.amenityPicture,
                                    fit: BoxFit.fitHeight,
                                  )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            amenity.amenityName,
                            style: FontsCustom.bodyHeading,
                          ),
                        ),
                        SizedBox(
                            height: 200,
                            width: 300,
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black, // Border color
                                    width: 2.0, // Border width
                                  ),
                                ),
                                child: DateSelector(
                                  amenity.recurrence,
                                  (date) {
                                    setState(() {
                                      selectedDate = date;
                                    });
                                  },
                                ))),
                        SizedBox(height: 30),
                        SizedBox(
                            height: 200,
                            width: 300,
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black, // Border color
                                    width: 2.0, // Border width
                                  ),
                                ),
                                child: TimeSelector(
                                  slots,
                                  (time) {
                                    setState(() {
                                      selectedTime = time;
                                    });
                                  },
                                ))),
                      ],
                    ),
                    SizedBox(height: 50),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorCustomScheme
                                  .appBarColor), // Change this color to your desired background color
                        ),
                        onPressed: () async {
                          users = await showDialog(
                              context: context,
                              builder: (context) {
                                return GroupMembers(context, users);
                              });
                        },
                        child: Text("Add Group Members")),
                    SizedBox(height: 100),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorCustomScheme
                                  .appBarColor), // Change this color to your desired background color
                        ),
                        onPressed: () async {
                          dynamic response =
                              await DatabaseQueries.makeAmmenityRequest(
                                  amenity.amenityId,
                                  users,
                                  parseStartTime(selectedTime),
                                  selectedDate);

                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: SizedBox(
                                  height: 100,
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
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty
                                                .all<Color>(ColorCustomScheme
                                                    .appBarColor), // Change this color to your desired background color
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            if (json.decode(response
                                                    .toString())['code'] ==
                                                200) router.pop();
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
