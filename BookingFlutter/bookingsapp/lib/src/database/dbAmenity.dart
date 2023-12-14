import 'dart:io';

import 'package:bookingsapp/src/constants/urls.dart';
import 'package:bookingsapp/src/functions/format.dart';
import 'package:bookingsapp/src/models/ammenity.dart';
import 'package:dio/dio.dart';

class DatabaseQueriesAmenity {
  DatabaseQueriesAmenity._();
  static Future<Response> getAmenityDetails(String amenityId) async {
    FormData formData = await getSessionForm();
    String pathAmenity = AmenityUrls.amenityDetail(amenityId: amenityId);
    var dio = Dio();
    var response = await dio.get(pathAmenity, data: formData);

    return response;
  }

  static Future<Response> getAmenityUser(String userId) async {
    FormData formData = await getSessionForm();
    String pathAmenity = AmenityUrls.amenityUser(userId: userId);
    var dio = Dio();
    var response = await dio.get(pathAmenity, data: formData);

    return response;
  }

  static Future<Response> getAmenitySlot(String amenityId) async {
    FormData formData = await getSessionForm();
    String pathAmenity = AmenityUrls.amenitySlot(amenityId: amenityId);
    var dio = Dio();
    var response = await dio.get(pathAmenity, data: formData);

    return response;
  }

  static Future<Response> getAmenityRegex(String like) async {
    FormData formData = await getSessionForm();
    String pathEvent = AmenityUrls.amenityRegex(like: like);
    var dio = Dio();
    var response = await dio.get(pathEvent, data: formData);

    return response;
  }

  static Future<void> createAmenity(
      String amenityName,
      String userId,
      String recurrence,
      List<dynamic> slot,
      File? image,
      double capcity,
      String description) async {
    String session_token = await getSessionToken();
    String path = AmenityUrls.amenity;
    FormData formData;
    List<dynamic> startTimes = slot.map((slots) => slots.startTime).toList();
    List<dynamic> endTimes = slot.map((slots) => slots.endTime).toList();

    var dio = Dio();
    if (image != null) {
      formData = FormData.fromMap({
        "session_token": session_token,
        "userId": userId,
        "amenityName": amenityName,
        "recurrence": recurrence.toLowerCase(),
        'eventPicture': await MultipartFile.fromFile(image.path,
            filename: '${image.hashCode}.jpg'),
        "startTimes": startTimes,
        "endTimes": endTimes,
        "capacity": capcity.toInt(),
        "description": description,
      });
    } else {
      formData = FormData.fromMap({
        "session_token": session_token,
        "userId": userId,
        "amenityName": amenityName,
        "recurrence": recurrence.toLowerCase(),
        "startTimes": startTimes,
        "endTimes": endTimes,
        "capacity": capcity.toInt(),
        "description": description,
      });
    }
    var response = await dio.post(path, data: formData);
  }
}

Future<List<Amenity>> getAmenity(String like) async {
  var response = await DatabaseQueriesAmenity.getAmenityRegex(like);

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
    var amenityUser = await DatabaseQueriesAmenity.getAmenityUser(userId);

    if (amenityUser.statusCode == 200) {
      List<dynamic> responseData = amenityUser.data;

      List<dynamic> typedData = [];

      for (var responseInd in amenityUser.data) {
        var responseAmenity = await DatabaseQueriesAmenity.getAmenityDetails(
            responseInd['amenityId']);

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
