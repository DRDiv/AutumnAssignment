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

  static Future<Response> getAmmenityDetails(String ammenityId) async {
    String pathAmenity = "$ipAdd/amenity/$ammenityId/";
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
}
