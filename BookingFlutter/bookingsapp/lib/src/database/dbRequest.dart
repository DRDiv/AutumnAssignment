import 'dart:io';

import 'package:bookingsapp/src/constants/urls.dart';
import 'package:bookingsapp/src/models/request.dart';
import 'package:dio/dio.dart';

class DatabaseQueriesRequest {
  static Future<Response> getUserRequest(String userId) async {
    String pathUser = RequestUrls.getUserRequest(userId: userId);
    var dio = Dio();
    var response = await dio.get(pathUser);

    return response;
  }

  static Future<dynamic> makeEventRequest(
      String eventId, String teamId, File? image) async {
    String path = RequestUrls.makeEventRequest();
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

  static Future<dynamic> makeAmmenityRequest(String amenityId,
      List<String> users, DateTime timeStart, DateTime date) async {
    String path = RequestUrls.makeAmmenityRequest();
    var dio = Dio();
    FormData formData;

    formData = FormData.fromMap({
      'amenity_id': amenityId,
      'users': users,
      'timeStart': timeStart,
      'date': date,
    });

    var response = await dio.post(path, data: formData);
    return response;
  }

  static Future<Response> getRequest(String userId) async {
    String pathUser = RequestUrls.getRequest(userId: userId);
    var dio = Dio();
    var response = await dio.get(pathUser);

    return response;
  }

  static Future<Response> deleteRequest(String reqId) async {
    String pathUser = RequestUrls.deleteRequest(reqId: reqId);
    var dio = Dio();
    var response = await dio.delete(pathUser);

    return response;
  }
}

Future<List<Requests>> getRequest(String userId) async {
  try {
    var bookingTeam = await DatabaseQueriesRequest.getUserRequest(userId);

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
