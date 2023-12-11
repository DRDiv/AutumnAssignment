import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> getImage(WidgetRef container) async {
  final pickedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedImage != null) {
    return File(pickedImage.path);
  }
  return null;
}

Future<DateTime?> getDate(BuildContext context, DateTime selectedDate) async {
  final DateTime today = DateTime.now();
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: today,
    lastDate: DateTime(2101),
  );

  return picked;
}

Future<TimeOfDay?> getTime(BuildContext context) async {
  final TimeOfDay now = TimeOfDay.now();

  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: now,
  );

  return picked;
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

  return DateTime.now();
}
