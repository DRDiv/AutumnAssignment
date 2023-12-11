import 'package:bookingsapp/src/database/dbRequest.dart';
import 'package:bookingsapp/src/models/user.dart';

class Event {
  String eventId = "", eventName = "", eventPicture = "", eventDate = "";
  int maxTeamSize = 0, minTeamSize = 0;
  double payment = 0;
  User userProvider = User.defaultUser();
  Event(this.eventId, this.eventName, this.eventPicture, this.eventDate,
      this.maxTeamSize, this.payment, this.userProvider);
  Event.defaultEvent();
  Future<void> setData(Map<String, dynamic> responseData) async {
    eventId = responseData["eventId"];
    eventName = responseData["eventName"];
    eventPicture = responseData["eventPicture"] ?? "";
    eventDate = responseData["eventDate"];
    maxTeamSize = responseData["maxTeamSize"];
    minTeamSize = responseData["minTeamSize"];

    payment = double.parse(responseData["payment"]);
    userProvider = User.set(
        (await DatabaseQueries.getUserDetails(responseData['userProvider']))
            .data);
  }
}
