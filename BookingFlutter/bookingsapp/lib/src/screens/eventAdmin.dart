import 'package:bookingsapp/src/components/loading.dart';
import 'package:bookingsapp/src/database/dbEvent.dart';
import 'package:bookingsapp/src/functions/format.dart';
import 'package:bookingsapp/src/providers/userLoggedProvider.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:bookingsapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import 'package:intl/intl.dart';

class EventAdmin extends ConsumerStatefulWidget {
  const EventAdmin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventAdminState();
}

class _EventAdminState extends ConsumerState<EventAdmin> {
  File? eventPicture;
  String userId = "";
  final TextEditingController _eventName = TextEditingController();
  final TextEditingController _eventDescription = TextEditingController();
  final TextEditingController _payment = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  double _minTeam = 1.0;
  double _maxTeam = 1.0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Theme(
      data: AppTheme.lightTheme(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Create Event",
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 2,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      (eventPicture == null)
                          ? const Center(
                              child: Icon(
                                Icons.category_sharp,
                                color: Colors.black,
                                size: 100,
                              ),
                            )
                          : Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.file(
                                  eventPicture!,
                                  fit: BoxFit.cover,
                                  width: 250,
                                ),
                              ),
                            ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: FloatingActionButton(
                          child: const Icon(Icons.add),
                          onPressed: () async {
                            File? eventPictureGet = await getImage(ref);
                            setState(() {
                              eventPicture = eventPictureGet;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: 0.8 * width,
                  child: TextFormField(
                    controller: _eventName,
                    decoration: const InputDecoration(
                      hintText: "Enter Event Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Center(
                  child: SizedBox(
                    width: 0.8 * width,
                    child: TextFormField(
                      controller: _eventDescription,
                      maxLines:
                          3, // Set the number of lines you want for description
                      decoration: const InputDecoration(
                          hintText: "Enter Event Description"),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: 0.5 * width,
                  child: TextFormField(
                    controller: TextEditingController(
                      text: DateFormat('dd-MM-yyyy').format(selectedDate),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? selectedDateGet =
                          await getDate(context, selectedDate);
                      if (selectedDateGet != null) {
                        setState(() {
                          selectedDate = selectedDateGet;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Date',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: () async {
                          DateTime? selectedDateGet =
                              await getDate(context, selectedDate);
                          if (selectedDateGet != null) {
                            setState(() {
                              selectedDate = selectedDateGet;
                            });
                          }
                        },
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 0.5 * width,
                  child: TextFormField(
                    controller: TextEditingController(
                      text: selectedTime.format(context),
                    ),
                    readOnly: true,
                    onTap: () async {
                      TimeOfDay? selectedTimeGet = await getTime(context);
                      if (selectedTimeGet != null) {
                        setState(() {
                          selectedTime = selectedTimeGet;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Time',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () async {
                          TimeOfDay? selectedTimeGet = await getTime(context);
                          if (selectedTimeGet != null) {
                            setState(() {
                              selectedTime = selectedTimeGet;
                            });
                          }
                        },
                      ),
                      border: OutlineInputBorder(),
                      // You can add more styling properties here as needed
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Min Team Size: ${_minTeam.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodyLarge),
                Slider(
                  value: _minTeam,
                  onChanged: (newValue) {
                    setState(() {
                      _minTeam = newValue;
                    });
                  },
                  min: 1,
                  max: 100,
                  divisions: 99,
                  label: _minTeam.toStringAsFixed(0),
                ),
                const SizedBox(height: 20),
                Text('Max Team Size: ${_maxTeam.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodyLarge),
                Slider(
                  value: _maxTeam,
                  onChanged: (newValue) {
                    setState(() {
                      _maxTeam = newValue;
                    });
                  },
                  min: 1,
                  max: 100,
                  divisions: 99,
                  label: _maxTeam.toStringAsFixed(0),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 0.8 * width,
                  child: TextFormField(
                    controller: _payment,
                    decoration: const InputDecoration(
                      hintText: "Enter Payment Amount",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 0.8 * width,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_eventName.text.isEmpty) {
                        showSnackBar('Please enter an event name.');
                        return;
                      }
                      if (_payment.text.isEmpty) {
                        showSnackBar('Please enter a payment amount.');
                        return;
                      }

                      if (double.parse(_payment.text) < 0) {
                        showSnackBar('Please enter valid payment amount.');
                        return;
                      }

                      if (_minTeam > _maxTeam) {
                        showSnackBar(
                            'Minimum team size must be less than Maximum team size.');
                        return;
                      }
                      showLoadingDialog(context);
                      await DatabaseQueriesEvent.createEvent(
                          _eventName.text,
                          ref.read(userLogged).userId,
                          DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          ),
                          _minTeam.toInt(),
                          _maxTeam.toInt(),
                          double.parse(_payment.text),
                          eventPicture,
                          _eventDescription.text);
                      router.pop();
                      router.pop();
                    },
                    child: const Text('CONFIRM'),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
