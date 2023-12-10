import 'dart:io';

import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/src/models/ammenity.dart';
import 'package:bookingsapp/src/models/event.dart';
import 'package:bookingsapp/src/models/request.dart';
import 'package:bookingsapp/src/models/team.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

Future<List<dynamic>> getBookingsIndvidual(String userId) async {
  try {
    var bookingUser = await DatabaseQueries.getBookingsUser(userId);

    if (bookingUser.statusCode == 200) {
      List<dynamic> responseData = bookingUser.data;

      List<dynamic> typedData = [];

      for (var responseInd in bookingUser.data) {
        if (responseInd['amenity'] != null) {
          var responseAmenity =
              await DatabaseQueries.getAmmenityDetails(responseInd['amenity']);
          Amenity amenity = Amenity.defaultAmenity();
          await amenity.setData(responseAmenity.data, responseInd['dateSlot'],
              responseInd['timeStart']);
          typedData.add(amenity);
        }
        if (responseInd['event'] != null) {
          var responseEvent =
              await DatabaseQueries.getEventDetails(responseInd['event']);
          Event event = Event.defaultEvent();

          await event.setData(responseEvent.data);
          typedData.add(event);
        }
      }

      return typedData;
    }
  } catch (e) {
    print(e);
  }

  return [];
}

final teamsList = StateProvider<List<String>>((ref) => []);
Future<List<dynamic>> getBookingsTeam(
    String userId, WidgetRef container) async {
  try {
    var bookingTeam = await DatabaseQueries.getBookingsTeam(userId);

    if (bookingTeam.statusCode == 200) {
      List<dynamic> responseData = bookingTeam.data;

      List<dynamic> typedData = [];
      List<String> teams = [];
      for (var responseInd in bookingTeam.data) {
        if (responseInd['amenity'] != null) {
          var responseAmenity =
              await DatabaseQueries.getAmmenityDetails(responseInd['amenity']);
          Amenity amenity = Amenity.defaultAmenity();
          await amenity.setData(responseAmenity.data, responseInd['dateSlot'],
              responseInd['timeStart']);
          typedData.add(amenity);
        }
        if (responseInd['event'] != null) {
          var responseEvent =
              await DatabaseQueries.getEventDetails(responseInd['event']);
          Event event = Event.defaultEvent();

          await event.setData(responseEvent.data);
          typedData.add(event);
        }
        teams.add((await DatabaseQueries.getTeamDetails(responseInd['teamId']))
            .data['teamName']);
      }
      container.read(teamsList).clear();
      container.read(teamsList).addAll(teams);
      return typedData;
    }
  } catch (e) {
    print(e);
  }

  return [];
}

Future<List<Requests>> getRequest(String userId) async {
  try {
    var bookingTeam = await DatabaseQueries.getUserRequest(userId);

    if (bookingTeam.statusCode == 200) {
      var responseData = bookingTeam.data;

      List<Requests> typedData = [];

      for (var requestindv in responseData) {
        Requests request = Requests.defaultRequest();
        await request.setData(requestindv);

        typedData.add(request);
      }
      return typedData;
    }
  } catch (e) {
    print(e);
  }

  return [];
}

Future<List<User>> getUsers(String like, List<User> users) async {
  List<String> userIds = users.map((user) => user.userId).toList();
  var response = await DatabaseQueries.getUserRegex(like);
  users = [];

  for (var indv in response.data) {
    if (!userIds.contains(indv['userId'])) {
      users.add(User.set(indv));
    }
  }

  return users;
}

Future<List<User>> getUsersGroup(String like, String userId) async {
  var response = await DatabaseQueries.getUserRegex(like);
  List<User> users = [];

  for (var indv in response.data) {
    if (indv['userId'] != userId) {
      User temp = User.set(indv);
      if (!temp.ammenityProvider) users.add(temp);
    }
  }

  return users;
}

Future<List<Team>> getTeams(String userId) async {
  try {
    var response = await DatabaseQueries.getUserTeams(userId);

    if (response.statusCode == 200) {
      List<Team> typedData = [];

      for (var responseInd in response.data) {
        Team team = Team.defaultTeam();
        await team.setData(responseInd);
        typedData.add(team);
      }

      return typedData;
    }
  } catch (e) {
    print(e);
  }

  return [];
}

Future<List<Amenity>> getAmenity(String like) async {
  var response = await DatabaseQueries.getAmenityRegex(like);
  List<Amenity> amenity = [];

  for (var indv in response.data) {
    Amenity amenityInd = Amenity.defaultAmenity();

    await amenityInd.setData(indv, "", "");

    amenity.add(amenityInd);
  }

  return amenity;
}

Future<List<dynamic>> getAmmenityUser(String userId) async {
  try {
    var amenityUser = await DatabaseQueries.getAmmenityUser(userId);

    if (amenityUser.statusCode == 200) {
      List<dynamic> responseData = amenityUser.data;

      List<dynamic> typedData = [];

      for (var responseInd in amenityUser.data) {
        var responseAmenity =
            await DatabaseQueries.getAmmenityDetails(responseInd['amenityId']);

        Amenity amenity = Amenity.defaultAmenity();

        await amenity.setData(responseAmenity.data, "", "");
        typedData.add(amenity);
      }

      return typedData;
    }
  } catch (e) {
    print(e);
  }

  return [];
}

Future<List<dynamic>> getEventUser(String userId) async {
  try {
    var amenityUser = await DatabaseQueries.getEventUser(userId);

    if (amenityUser.statusCode == 200) {
      List<dynamic> responseData = amenityUser.data;

      List<dynamic> typedData = [];

      for (var responseInd in amenityUser.data) {
        var responseEvent =
            await DatabaseQueries.getEventDetails(responseInd['eventId']);

        Event event = Event.defaultEvent();

        await event.setData(responseEvent.data);
        typedData.add(event);
      }

      return typedData;
    }
  } catch (e) {
    print(e);
  }

  return [];
}

Future<List<Event>> getEvents(String like) async {
  var response = await DatabaseQueries.getEventRegex(like);
  List<Event> events = [];

  for (var indv in response.data) {
    Event eventInd = Event.defaultEvent();
    await eventInd.setData(indv);

    events.add(eventInd);
  }
  return events;
}

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
