import 'dart:convert';

class User {
  String userId = "";
  String userName = "";
  Map data = {};
  int penalties = 0;
  bool ammenityProvider = false;
  User(this.userId, this.userName, this.data, this.penalties,
      this.ammenityProvider);
  User.set(Map<String, dynamic> responseData) {
    userId = responseData['userId'].toString();
    userName = responseData['userName'].toString();
    data = responseData['data'].runtimeType.toString() == "String"
        ? json.decode(responseData['data'])
        : responseData['data'];
    penalties = responseData['penalties'];
    ammenityProvider = responseData['ammenityProvider'];
  }
  User.defaultUser();
}
