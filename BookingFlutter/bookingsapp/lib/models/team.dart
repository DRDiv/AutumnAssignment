import 'package:bookingsapp/database/database.dart';
import 'package:bookingsapp/models/event.dart';
import 'package:bookingsapp/models/user.dart';

class Team {
  String teamId = "", teamName = "";
  List<User> users = [];
  Map<String, dynamic> isAdmin = {};
  List<Event> events = [];
  Team(this.teamId, this.teamName, this.users, this.isAdmin, this.events);
  Team.defaultTeam();
  Future<void> setData(Map<String, dynamic> responseData) async {
    teamId = responseData["teamId"];
    teamName = responseData["teamName"];
    for (var key in responseData['users']) {
      users.add(User.set((await DatabaseQueries.getUserDetails(key)).data));
    }
    isAdmin = responseData["isAdmin"];
    for (var key in responseData['bookedEvents']) {
      Event event = Event.defaultEvent();
      await event.setData((await DatabaseQueries.getEventDetails(key)).data);
      events.add(event);
    }
  }
}
