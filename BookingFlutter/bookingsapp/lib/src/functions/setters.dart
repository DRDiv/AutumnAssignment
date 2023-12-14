import 'package:bookingsapp/src/database/dbAmenity.dart';
import 'package:bookingsapp/src/database/dbEvent.dart';
import 'package:bookingsapp/src/database/dbUser.dart';
import 'package:bookingsapp/src/functions/format.dart';
import 'package:bookingsapp/src/models/ammenity.dart';
import 'package:bookingsapp/src/models/event.dart';
import 'package:bookingsapp/src/models/team.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:bookingsapp/src/providers/amenityBookingProvider.dart';
import 'package:bookingsapp/src/providers/eventBookingProviders.dart';
import 'package:bookingsapp/src/providers/userLoggedProvider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> setUserDetailsAndSessionToken(
  Uri url,
  WidgetRef ref,
) async {
  var response =
      await DatabaseQueriesUser.getUserDetails(url.queryParameters['userId']!);
  ref.read(userLogged.notifier).state = User.set(response.data);

  const storage = FlutterSecureStorage();
  await storage.write(
      key: "sessionToken", value: url.queryParameters['sessionToken']);
  await DatabaseQueriesUser.updateSessionToken(
      ref.read(userLogged).userId, url.queryParameters['sessionToken']!);
}

List<Team> setFilterTeams(List<Team> teams, String query) {
  if (query.isEmpty) {
    return teams;
  } else {
    return teams
        .where(
            (team) => team.teamName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

Future<void> setDataEventBooking(String eventId, WidgetRef ref) async {
  Event e = Event.defaultEvent();
  await e.setData((await DatabaseQueriesEvent.getEventDetails(eventId)).data);
  ref.read(eventBooking.notifier).state = e;
}

Future<String> setDataAmenityBooking(String amenityId, WidgetRef ref) async {
  Amenity a = Amenity.defaultAmenity();
  await a.setData(
      (await DatabaseQueriesAmenity.getAmenityDetails(amenityId)).data, "", "");
  var response = await DatabaseQueriesAmenity.getAmenitySlot(a.amenityId);

  ref.read(userAmenity.notifier).state = [];
  ref.read(slots.notifier).state = [];
  ref.read(userAmenity).add(ref.read(userLogged).userId);
  for (var indv in response.data) {
    ref
        .read(slots)
        .add(formatTimeRange(indv['amenitySlotStart'], indv['amenitySlotEnd']));
  }

  ref.read(amenityBooking.notifier).state = a;
  return ref.read(slots)[0];
}

Future<List<User>> setUsers(String like, List<User> userList) async {
  List<User> users = await getUsers(like, userList);
  return users;
}
