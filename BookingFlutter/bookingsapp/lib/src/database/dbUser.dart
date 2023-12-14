import 'package:bookingsapp/src/constants/urls.dart';
import 'package:bookingsapp/src/functions/format.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DatabaseQueriesUser {
  static Future<Response> getCurrentUser(String token) async {
    FormData formData = await getSessionForm();
    String path = UserUrls.getCurrentUser(token: token);
    var dio = Dio();
    var response = await dio.get(path, data: formData);
    return response;
  }

  static Future<Response> adminLogin(String username, String password) async {
    String session_token = await getSessionToken();
    String path = UserUrls.adminLogin();
    var dio = Dio();
    var formData = FormData.fromMap({
      "session_token": session_token,
      'username': username,
      'password': password,
    });
    var response = await dio.get(path, data: formData);
    return response;
  }

  static Future<Response> getUserDetails(String userId) async {
    FormData formData = await getSessionForm();
    String pathUser = UserUrls.getUserDetails(userId: userId);
    var dio = Dio();
    var response = await dio.get(pathUser, data: formData);

    return response;
  }

  static Future<Response> getUserRegex(String like) async {
    FormData formData = await getSessionForm();
    String pathUser = UserUrls.getUserRegex(like: like);
    var dio = Dio();
    var response = await dio.get(pathUser, data: formData);

    return response;
  }

  static Future<Response> updateSessionToken(
      String userId, String token) async {
    FormData formData = await getSessionForm();
    String path = UserUrls.updateSessionToken(userId: userId, token: token);
    var dio = Dio();
    var response = await dio.put(path, data: formData);
    return response;
  }
}

Future<String> getInitialLocation(WidgetRef ref) async {
  const storage = FlutterSecureStorage();

  String token = await storage.read(key: "sessionToken") ?? " ";

  try {
    var currentUser = await DatabaseQueriesUser.getCurrentUser(token);

    if (currentUser.statusCode == 200) {
      var response =
          await DatabaseQueriesUser.getUserDetails(currentUser.data['userId']);
      Map<String, dynamic> responseData = response.data;

      User userlogged = User.set(responseData);

      ref.watch(userLogged.notifier).state = userlogged;
      if (userlogged.ammenityProvider) {
        return "/homeAdmin";
      }
      return "/home";
    } else if (currentUser.statusCode == 404) {
      return "/login";
    } else {
      return "/login";
    }
  } catch (e) {
    return "/login";
  }
}

Future<List<User>> getUsers(String like, List<User> users) async {
  List<String> userIds = users.map((user) => user.userId).toList();
  var response = await DatabaseQueriesUser.getUserRegex(like);
  users = [];

  for (var indv in response.data) {
    if (!userIds.contains(indv['userId'])) {
      users.add(User.set(indv));
    }
  }

  return users;
}

Future<List<User>> getUsersGroup(String like, String userId) async {
  var response = await DatabaseQueriesUser.getUserRegex(like);
  List<User> users = [];

  for (var indv in response.data) {
    if (indv['userId'] != userId) {
      User temp = User.set(indv);
      if (!temp.ammenityProvider) users.add(temp);
    }
  }

  return users;
}
