import 'dart:io';

import 'package:bookingsapp/src/constants/urls.dart';
import 'package:bookingsapp/src/functions/format.dart';
import 'package:bookingsapp/src/models/event.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DatabaseQueriesEvent {
  static Future<void> createEvent(
    String eventName,
    String userId,
    DateTime eventDate,
    int minTeamSize,
    int maxTeamSize,
    double payment,
    File? image,
  ) async {
    String session_token = await getSessionToken();
    String path = EventUrls.event;
    FormData formData;
    var dio = Dio();
    if (image != null) {
      formData = FormData.fromMap({
        "session_token": session_token,
        "userId": userId,
        "eventName": eventName,
        "eventDate": eventDate.toIso8601String(),
        "minTeamSize": minTeamSize,
        "maxTeamSize": maxTeamSize,
        "payment": payment,
        'eventPicture': await MultipartFile.fromFile(image.path,
            filename: '${image.hashCode}.jpg'),
      });
    } else {
      formData = FormData.fromMap({
        "session_token": session_token,
        "userId": userId,
        "eventName": eventName,
        "eventDate": eventDate.toIso8601String(),
        "minTeamSize": minTeamSize,
        "maxTeamSize": maxTeamSize,
        "payment": payment,
      });
    }
    var response = await dio.post(path, data: formData);
  }

  static Future<Response> getEventDetails(String eventId) async {
    FormData formData = await getSessionForm();
    String pathEvent = EventUrls.eventDetail(eventId: eventId);
    var dio = Dio();

    var response = await dio.get(pathEvent, data: formData);

    return response;
  }

  static Future<Response> getEventUser(String userId) async {
    FormData formData = await getSessionForm();
    String pathEvent = EventUrls.eventUser(userId: userId);
    var dio = Dio();
    var response = await dio.get(pathEvent, data: formData);

    return response;
  }

  static Future<Response> getEventRegex(String like) async {
    FormData formData = await getSessionForm();
    String pathEvent = EventUrls.eventRegex(like: like);
    var dio = Dio();
    var response = await dio.get(pathEvent, data: formData);

    return response;
  }
}

Future<List<dynamic>> getEventUser(String userId) async {
  try {
    var amenityUser = await DatabaseQueriesEvent.getEventUser(userId);

    if (amenityUser.statusCode == 200) {
      List<dynamic> typedData = [];

      for (var responseInd in amenityUser.data) {
        var responseEvent =
            await DatabaseQueriesEvent.getEventDetails(responseInd['eventId']);

        Event event = Event.defaultEvent();

        await event.setData(responseEvent.data);
        typedData.add(event);
      }

      return typedData;
    }
  } catch (e) {}

  return [];
}

Future<List<Event>> getEvents(String like) async {
  var response = await DatabaseQueriesEvent.getEventRegex(like);
  List<Event> events = [];

  for (var indv in response.data) {
    Event eventInd = Event.defaultEvent();
    await eventInd.setData(indv);

    events.add(eventInd);
  }
  return events;
}
