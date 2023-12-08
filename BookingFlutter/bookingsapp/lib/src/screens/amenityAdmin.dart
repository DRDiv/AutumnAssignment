import 'dart:io';

import 'package:bookingsapp/src/assets/colors.dart';
import 'package:bookingsapp/src/assets/fonts.dart';
import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class Slot {
  TimeOfDay startTime;
  TimeOfDay endTime;

  Slot({required this.startTime, required this.endTime});
}

class SlotsEditor extends StatefulWidget {
  List<Map<String, dynamic>> slotDataList;
  List<Slot> slots;
  SlotsEditor(this.slotDataList, this.slots);
  @override
  _SlotsEditorState createState() => _SlotsEditorState();
}

class _SlotsEditorState extends State<SlotsEditor> {
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  List<Map<String, dynamic>> collectSlotData() {
    for (final slot in widget.slots) {
      final slotData = {
        'startTimeHour': slot.startTime.hour,
        'startTimeMinute': slot.startTime.minute,
        'endTimeHour': slot.endTime.hour,
        'endTimeMinute': slot.endTime.minute,
      };
      widget.slotDataList.add(slotData);
    }

    return widget.slotDataList;
  }

  bool isSlotOverlapping(Slot newSlot) {
    for (final slot in widget.slots) {
      if (newSlot.startTime.hour * 60 + newSlot.startTime.minute <
              slot.endTime.hour * 60 + slot.endTime.minute &&
          newSlot.endTime.hour * 60 + newSlot.endTime.minute >
              slot.startTime.hour * 60 + slot.startTime.minute) {
        return true;
      }
    }
    return false;
  }

  void addSlot() {
    final newSlot =
        Slot(startTime: selectedStartTime, endTime: selectedEndTime);

    if (!isSlotOverlapping(newSlot)) {
      setState(() {
        widget.slots.add(newSlot);
        selectedStartTime = TimeOfDay.now();
        selectedEndTime = TimeOfDay.now();
      });
    }
  }

  void removeSlot(int index) {
    setState(() {
      widget.slots.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TimePicker(
                labelText: 'Start Time',
                selectedTime: selectedStartTime,
                onTimeChanged: (time) {
                  setState(() {
                    selectedStartTime = time;
                  });
                },
              ),
            ),
            Expanded(
              child: TimePicker(
                labelText: 'End Time',
                selectedTime: selectedEndTime,
                onTimeChanged: (time) {
                  setState(() {
                    selectedEndTime = time;
                  });
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: addSlot,
            ),
          ],
        ),
        SizedBox(height: 16),
        Text('SELECTED SLOTS', style: FontsCustom.bodyHeading),
        (widget.slots.isEmpty)
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('No Slot Selected', style: FontsCustom.bodyBigText),
              )
            : Container(
                constraints: BoxConstraints(
                  maxHeight: 300.0, // Maximum height you want
                ),
                height: widget.slots.length * 100,
                child: ListView.builder(
                  itemCount: widget.slots.length,
                  itemBuilder: (context, index) {
                    final slot = widget.slots[index];
                    return SlotDisplay(
                      slot: slot,
                      onRemove: () {
                        removeSlot(index);
                      },
                    );
                  },
                ),
              ),
      ],
    );
  }
}

class TimePicker extends StatelessWidget {
  final String labelText;
  final TimeOfDay selectedTime;
  final ValueChanged<TimeOfDay> onTimeChanged;

  TimePicker({
    required this.labelText,
    required this.selectedTime,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(labelText),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(ColorSchemes.secondayColor),
          ),
          onPressed: () async {
            final pickedTime = await showTimePicker(
              context: context,
              initialTime: selectedTime,
            );

            if (pickedTime != null) {
              onTimeChanged(pickedTime);
            }
          },
          child: Text(
            selectedTime.format(context),
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}

class SlotDisplay extends StatelessWidget {
  final Slot slot;
  final VoidCallback onRemove;

  SlotDisplay({required this.slot, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Start Time: ${slot.startTime.format(context)}'),
      subtitle: Text('End Time: ${slot.endTime.format(context)}'),
      trailing: IconButton(
        icon: Icon(Icons.remove),
        onPressed: onRemove,
      ),
    );
  }
}

class AmenityAdmin extends ConsumerStatefulWidget {
  const AmenityAdmin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AmenityAdminState();
}

class _AmenityAdminState extends ConsumerState<AmenityAdmin> {
  List<Map<String, dynamic>> _slotDataList = [];
  List<Slot> _slots = [];
  File? _amenityPicture;
  String _userId = "";
  String _selectedOption = 'Daily';

  List<String> options = [
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
    'One Time',
  ];
  TextEditingController _amenityName = TextEditingController();
  double _capacity = 1.0;
  Future<void> _getImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _amenityPicture = File(pickedImage.path);
      });
    }
  }

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
                      .whiteColor, // Change to your desired background color
                ),
                child: Stack(
                  children: [
                    (_amenityPicture == null)
                        ? Center(
                            child: Icon(
                              Icons.category_sharp,
                              size: 100,
                            ),
                          )
                        : Center(
                            child: ClipRRect(
                                child: Image.file(
                              _amenityPicture!,
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
                  controller: _amenityName,
                  decoration: InputDecoration(hintText: "Enter Amenity Name"),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text('Capacity: ${_capacity.toStringAsFixed(0)}',
                style: FontsCustom.bodyBigText),
            Slider(
              thumbColor: ColorSchemes.secondayColor,
              activeColor: ColorSchemes.secondayColor,
              inactiveColor: ColorSchemes.tertiaryColor,
              value: _capacity,
              onChanged: (newValue) {
                setState(() {
                  _capacity = newValue;
                });
              },
              min: 1,
              max: 200,
              divisions: 199, // Number of discrete divisions
              label: _capacity.toStringAsFixed(0),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Select Recurrance: ',
                  style: FontsCustom.bodyBigText,
                ),
                DropdownButton<String>(
                  value: _selectedOption,
                  items: options.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedOption = newValue!;
                    });
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SlotsEditor(_slotDataList, _slots),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      ColorSchemes.secondayColor),
                ),
                onPressed: () async {
                  if (_amenityName.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Amenity name cannot be empty'),
                      ),
                    );
                    return;
                  }
                  if (_slots.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("No slots selected"),
                      ),
                    );
                  }
                  await DatabaseQueries.createAmenity(
                      _amenityName.text,
                      ref.read(userLogged).userId,
                      _selectedOption,
                      _slots,
                      _amenityPicture,
                      _capacity);
                  router.pop();
                },
                child: Text('Confirm'))
          ],
        ),
      ),
    );
  }
}
