import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/src/models/event.dart';
import 'package:bookingsapp/src/models/user.dart';

class Team {
  String teamId = "", teamName = "";
  List<User> users = [];
  Map<String, dynamic> isAdmin = {};
  Map<String, dynamic> isReq = {};
  List<Event> events = [];
  Team(this.teamId, this.teamName, this.users, this.isAdmin, this.isReq,
      this.events);
  Team.defaultTeam();
  Future<void> setData(Map<String, dynamic> responseData) async {
    teamId = responseData["teamId"];
    teamName = responseData["teamName"];
    for (var key in responseData['users']) {
      users.add(User.set((await DatabaseQueries.getUserDetails(key)).data));
    }
    isAdmin = responseData["isAdmin"];
    isReq = responseData["isReq"];
    for (var key in responseData['bookedEvents']) {
      Event event = Event.defaultEvent();
      await event.setData((await DatabaseQueries.getEventDetails(key)).data);
      events.add(event);
    }
  }
}
