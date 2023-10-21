import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ip = StateProvider<String>((ref) => "http://10.81.50.27:8000");
final String ipAdd = "http://10.81.50.27:8000";

class DatabaseQueries {
  static get dio => null;

  static Future<Response> getCurrentUser(String token) async {
    String path = "$ipAdd/user/session/$token/";
    var dio = Dio();
    var response = await dio.get(path);
    return response;
  }

  static Future<Response> getUserDetails(String userId) async {
    String pathUser = "$ipAdd/user/$userId/";
    var dio = Dio();
    var response = await dio.get(pathUser);

    return response;
  }

  static Future<Response> getUserRegex(String like) async {
    String pathUser = "$ipAdd/user/regex/$like/";
    var dio = Dio();
    var response = await dio.get(pathUser);

    return response;
  }

  static Future<Response> updateSessionToken(
      String userId, String token) async {
    String path = "$ipAdd/user/session/$userId/$token/";
    var dio = Dio();
    var response = await dio.put(path);
    return response;
  }

  static Future<Response> getUserTeams(String userId) async {
    String pathUser = "$ipAdd/team/user/$userId/";
    var dio = Dio();
    var response = await dio.get(pathUser);

    return response;
  }

  static Future<Response> getTeamDetails(String teamId) async {
    String pathTeam = "$ipAdd/team/$teamId/";
    var dio = Dio();
    var response = await dio.get(pathTeam);

    return response;
  }

  static Future<Response> addUserTeam(String teamId, String userId) async {
    String pathTeam = "$ipAdd/team/$teamId/adduser/$userId/";
    var dio = Dio();
    var response = await dio.get(pathTeam);

    return response;
  }

  static Future<Response> addAdmin(String teamId, String userId) async {
    String pathTeam = "$ipAdd/team/$teamId/makeadmin/$userId/";
    var dio = Dio();
    var response = await dio.get(pathTeam);

    return response;
  }

  static Future<Response> getAmmenityDetails(String ammenityId) async {
    String pathAmenity = "$ipAdd/amenity/$ammenityId/";
    var dio = Dio();
    var response = await dio.get(pathAmenity);

    return response;
  }

  static Future<Response> getAmmenitySlot(String ammenityId) async {
    String pathAmenity = "$ipAdd/amenity/getslot/$ammenityId/";
    var dio = Dio();
    var response = await dio.get(pathAmenity);

    return response;
  }

  static Future<Response> getEventDetails(String eventId) async {
    String pathEvent = "$ipAdd/event/$eventId/";
    var dio = Dio();
    var response = await dio.get(pathEvent);

    return response;
  }

  static Future<Response> getEventRegex(String like) async {
    String pathEvent = "$ipAdd/event/regex/$like/";
    var dio = Dio();
    var response = await dio.get(pathEvent);

    return response;
  }

  static Future<Response> getAmenityRegex(String like) async {
    String pathEvent = "$ipAdd/amenity/regex/$like/";
    var dio = Dio();
    var response = await dio.get(pathEvent);

    return response;
  }

  static Future<Response> getBookingsUser(String userId) async {
    String pathBooking = '$ipAdd/booking/individual/$userId/';
    var dio = Dio();
    var response = await dio.get(pathBooking);

    return response;
  }

  static Future<Response> getBookingsTeam(String userId) async {
    String pathBooking = '$ipAdd/booking/team/$userId/';
    var dio = Dio();
    var response = await dio.get(pathBooking);

    return response;
  }

  static Future<dynamic> makeEventRequest(
      String eventId, String teamId, File? image) async {
    String path = '$ipAdd/request/';
    var dio = Dio();
    FormData formData;
    if (image == null) {
      formData = FormData.fromMap({
        'event_id': eventId,
        'team_id': teamId,
      });
    } else {
      formData = FormData.fromMap({
        'event_id': eventId,
        'team_id': teamId,
        'payment_image':
            await MultipartFile.fromFile(image.path, filename: 'image.jpg'),
      });
    }
    var response = await dio.post(path, data: formData);
    return response;
  }

  static Future<dynamic> makeAmmenityRequest(
    String amenityId,
    List<String> users,
    DateTime timeStart,
    DateTime date,
  ) async {
    String path = '$ipAdd/request/';
    var dio = Dio();
    FormData formData;

    formData = FormData.fromMap({
      'amenity_id': amenityId,
      'users': users,
      'timeStart': timeStart,
      'date': date
    });

    var response = await dio.post(path, data: formData);
    return response;
  }

  static Future<void> createTeam(
      String teamName, List<String> users, String userlogged) async {
    String path = '$ipAdd/team/';
    var dio = Dio();
    FormData formData;
    Map<String, bool> isAdmin =
        Map.fromIterable(users, key: (user) => user, value: (_) => false);
    isAdmin[userlogged] = true;

    formData = FormData.fromMap({
      'teamName': teamName,
      'users': users,
      'isAdmin': isAdmin,
    });

    var response = await dio.post(path, data: formData);
  }
}
