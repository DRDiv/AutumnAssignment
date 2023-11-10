import 'package:bookingsapp/src/assets/colors.dart';
import 'package:bookingsapp/src/assets/fonts.dart';
import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
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
  TextEditingController _eventName = TextEditingController();
  TextEditingController _payment = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _getImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        eventPicture = File(pickedImage.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: today,
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay now = TimeOfDay.now();

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: now,
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  double _minTeam = 1.0;
  double _maxTeam = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "BOOKING\$",
          style: FontsCustom.heading,
        ),
        centerTitle: true,
        backgroundColor: ColorSchemes.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Center(
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: ColorSchemes
                      .backgroundColor, // Change to your desired background color
                ),
                child: Stack(
                  children: [
                    (eventPicture == null)
                        ? Center(
                            child: Icon(
                              Icons.category_sharp,
                              size: 100,
                            ),
                          )
                        : Center(
                            child: ClipRRect(
                                child: Image.file(
                              eventPicture!,
                              fit: BoxFit.fitHeight,
                            )),
                          ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: FloatingActionButton(
                        backgroundColor: ColorSchemes.secondayColor,
                        child: Icon(Icons.add),
                        onPressed: _getImage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Center(
              child: SizedBox(
                width: 200,
                child: TextFormField(
                  controller: _eventName,
                  decoration: InputDecoration(hintText: "Enter Event Name"),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Text(
                'Selected Date ${DateFormat('dd-MM-yyyy').format(selectedDate)}',
                style: FontsCustom.bodyBigText),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(ColorSchemes
                    .secondayColor), // Change this color to your desired background color
              ),
              onPressed: () => _selectDate(context),
              child: Text('Select Date'),
            ),
            SizedBox(
              height: 10,
            ),
            Text('Selected Time ${selectedTime.format(context)}',
                style: FontsCustom.bodyBigText),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(ColorSchemes
                    .secondayColor), // Change this color to your desired background color
              ),
              onPressed: () => _selectTime(context),
              child: Text('Select Time'),
            ),
            SizedBox(
              height: 20,
            ),
            Text('Min Team Size: ${_minTeam.toStringAsFixed(0)}',
                style: FontsCustom.bodyBigText),
            Slider(
              thumbColor: ColorSchemes.secondayColor,
              activeColor: ColorSchemes.secondayColor,
              inactiveColor: ColorSchemes.tertiaryColor,
              value: _minTeam,
              onChanged: (newValue) {
                setState(() {
                  _minTeam = newValue;
                });
              },
              min: 1,
              max: 100,
              divisions: 99, // Number of discrete divisions
              label: _minTeam.toStringAsFixed(0),
            ),
            SizedBox(
              height: 20,
            ),
            Text('Max Team Size: ${_maxTeam.toStringAsFixed(0)}',
                style: FontsCustom.bodyBigText),
            Slider(
              thumbColor: ColorSchemes.secondayColor,
              activeColor: ColorSchemes.secondayColor,
              inactiveColor: ColorSchemes.tertiaryColor,
              value: _maxTeam,
              onChanged: (newValue) {
                setState(() {
                  _maxTeam = newValue;
                });
              },
              min: 1,
              max: 100,
              divisions: 99, // Number of discrete divisions
              label: _maxTeam.toStringAsFixed(0),
            ),
            Center(
              child: SizedBox(
                width: 200,
                child: TextFormField(
                  controller: _payment,
                  decoration: InputDecoration(hintText: "Enter Payment Amount"),
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(ColorSchemes
                      .secondayColor), // Change this color to your desired background color
                ),
                onPressed: () async {
                  if (_eventName.text.isEmpty) {
                    // Name field is empty, show an error message.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter an event name.'),
                      ),
                    );
                    return;
                  }

                  if (_payment.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter a payment amount.'),
                      ),
                    );
                    return;
                  }

                  if (_minTeam > _maxTeam) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Minimum team size must be less than Maximum team size.'),
                      ),
                    );
                    return;
                  }
                  await DatabaseQueries.createEvent(
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
                      eventPicture);
                  router.pop();
                },
                child: Text('Confirm')),
          ],
        ),
      ),
    );
  }
}
