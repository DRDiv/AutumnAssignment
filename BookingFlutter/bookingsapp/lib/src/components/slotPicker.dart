import 'package:bookingsapp/src/theme/theme.dart';
import 'package:flutter/material.dart';

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
    return Theme(
      data: AppTheme.lightTheme(),
      child: Column(
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
                color: Theme.of(context).primaryColor,
                onPressed: addSlot,
              ),
            ],
          ),
          SizedBox(height: 16),
          Text('SELECTED SLOTS',
              style: Theme.of(context).textTheme.displaySmall!),
          (widget.slots.isEmpty)
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('No Slot Selected',
                      style: Theme.of(context).textTheme.bodyLarge!),
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
      ),
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
