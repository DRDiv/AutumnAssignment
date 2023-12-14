import 'package:bookingsapp/src/constants/urls.dart';
import 'package:bookingsapp/src/database/dbAmenity.dart';
import 'package:bookingsapp/src/database/dbEvent.dart';
import 'package:bookingsapp/src/database/dbTeam.dart';
import 'package:bookingsapp/src/functions/format.dart';
import 'package:bookingsapp/src/models/ammenity.dart';
import 'package:bookingsapp/src/models/event.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DatabaseQueriesBookings {
  static Future<Response> requestToBooking(String reqId) async {
    String pathBooking = BookingUrls.requestToBooking(reqId: reqId);

    var dio = Dio();
    FormData formData = await getSessionForm();

    var response = await dio.get(pathBooking, data: formData);

    return response;
  }

  static Future<Response> getBookingsUser(String userId) async {
    FormData formData = await getSessionForm();
    String pathBooking = BookingUrls.getBookingsUser(userId: userId);
    var dio = Dio();
    var response = await dio.get(pathBooking, data: formData);

    return response;
  }

  static Future<Response> getBookingsTeam(String userId) async {
    FormData formData = await getSessionForm();
    String pathBooking = BookingUrls.getBookingsTeam(userId: userId);
    var dio = Dio();
    var response = await dio.get(pathBooking, data: formData);

    return response;
  }
}

Future<List<dynamic>> getBookingsIndvidual(String userId) async {
  try {
    var bookingUser = await DatabaseQueriesBookings.getBookingsUser(userId);

    if (bookingUser.statusCode == 200) {
      List<dynamic> responseData = bookingUser.data;

      List<dynamic> typedData = [];

      for (var responseInd in bookingUser.data) {
        if (responseInd['amenity'] != null) {
          var responseAmenity = await DatabaseQueriesAmenity.getAmenityDetails(
              responseInd['amenity']);
          Amenity amenity = Amenity.defaultAmenity();
          await amenity.setData(responseAmenity.data, responseInd['dateSlot'],
              responseInd['timeStart']);
          typedData.add(amenity);
        }
        if (responseInd['event'] != null) {
          var responseEvent =
              await DatabaseQueriesEvent.getEventDetails(responseInd['event']);
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
    var bookingTeam = await DatabaseQueriesBookings.getBookingsTeam(userId);

    if (bookingTeam.statusCode == 200) {
      List<dynamic> responseData = bookingTeam.data;

      List<dynamic> typedData = [];
      List<String> teams = [];
      for (var responseInd in bookingTeam.data) {
        if (responseInd['amenity'] != null) {
          var responseAmenity = await DatabaseQueriesAmenity.getAmenityDetails(
              responseInd['amenity']);
          Amenity amenity = Amenity.defaultAmenity();
          await amenity.setData(responseAmenity.data, responseInd['dateSlot'],
              responseInd['timeStart']);
          typedData.add(amenity);
        }
        if (responseInd['event'] != null) {
          var responseEvent =
              await DatabaseQueriesEvent.getEventDetails(responseInd['event']);
          Event event = Event.defaultEvent();

          await event.setData(responseEvent.data);
          typedData.add(event);
        }
        teams.add(
            (await DatabaseQueriesTeam.getTeamDetails(responseInd['teamId']))
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
