import 'package:bookingsapp/src/constants/urls.dart';
import 'package:bookingsapp/src/functions/format.dart';
import 'package:bookingsapp/src/models/team.dart';
import 'package:dio/dio.dart';

class DatabaseQueriesTeam {
  DatabaseQueriesTeam._();
  static Future<Response> getTeamDetails(String teamId) async {
    FormData formData = await getSessionForm();
    String pathTeam = TeamUrls.getTeamDetails(teamId: teamId);
    var dio = Dio();
    var response = await dio.get(pathTeam, data: formData);

    return response;
  }

  static Future<Response> addUserTeam(String teamId, String userId) async {
    FormData formData = await getSessionForm();
    String pathTeam = TeamUrls.addUserTeam(teamId: teamId, userId: userId);
    var dio = Dio();
    var response = await dio.get(pathTeam, data: formData);

    return response;
  }

  static Future<Response> reqUserTeam(
      String teamId, String userId, bool state) async {
    String session_token = await getSessionToken();
    String pathTeam = TeamUrls.reqUserTeam(teamId: teamId, state: state);
    var dio = Dio();
    FormData formData = FormData.fromMap({
      "session_token": session_token,
      'userId': userId,
      'state': state,
    });
    var response = await dio.post(pathTeam, data: formData);

    return response;
  }

  static Future<Response> addAdmin(String teamId, String userId) async {
    FormData formData = await getSessionForm();
    String pathTeam = TeamUrls.addAdmin(teamId: teamId, userId: userId);
    var dio = Dio();
    var response = await dio.get(pathTeam, data: formData);

    return response;
  }

  static Future<Response> getUserTeams(String userId) async {
    FormData formData = await getSessionForm();
    String pathUser = TeamUrls.getUserTeams(userId: userId);
    var dio = Dio();
    var response = await dio.get(pathUser, data: formData);

    return response;
  }

  static Future<void> createTeam(
      String teamName, List<String> users, String userlogged) async {
    String session_token = await getSessionToken();
    String path = TeamUrls.createTeam();
    var dio = Dio();
    FormData formData;
    Map<String, bool> isAdmin =
        Map.fromIterable(users, key: (user) => user, value: (_) => false);
    isAdmin[userlogged] = true;
    Map<String, bool> isReq =
        Map.fromIterable(users, key: (user) => user, value: (_) => true);
    isReq[userlogged] = false;

    formData = FormData.fromMap({
      "session_token": session_token,
      'teamName': teamName,
      'users': users,
      'isAdmin': isAdmin,
      'isReq': isReq
    });

    var response = await dio.post(path, data: formData);
  }
}

Future<List<Team>> getTeams(String userId) async {
  try {
    var response = await DatabaseQueriesTeam.getUserTeams(userId);

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
