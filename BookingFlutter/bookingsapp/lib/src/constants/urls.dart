import 'package:flutter_riverpod/flutter_riverpod.dart';

final ip = StateProvider<String>((ref) => "http://192.168.29.33:8000");
final String ipAdd = "http://192.168.29.33:8000";

class EventUrls {
  static String event = '$ipAdd/event/';
  static String eventDetail({required String eventId}) {
    return "$ipAdd/event/$eventId/";
  }

  static String eventUser({required String userId}) {
    return "$ipAdd/event/getbyuser/$userId/";
  }

  static String eventRegex({required String like}) {
    return "$ipAdd/event/regex/$like/";
  }
}

class AmenityUrls {
  static String amenity = '$ipAdd/amenity/';
  static String amenityDetail({required String amenityId}) {
    return "$ipAdd/amenity/$amenityId/";
  }

  static String amenityUser({required String userId}) {
    return "$ipAdd/amenity/getbyuser/$userId/";
  }

  static String amenitySlot({required String amenityId}) {
    return "$ipAdd/amenity/getslot/$amenityId/";
  }

  static String amenityRegex({required String like}) {
    return "$ipAdd/amenity/regex/$like/";
  }
}

class BookingUrls {
  static String deleteBooking({required String bookingId}) {
    return "$ipAdd/booking/$bookingId/";
  }

  static String requestToBooking({required String reqId}) {
    return "$ipAdd/request/tobooking/$reqId";
  }

  static String getBookingsUser({required String userId}) {
    return '$ipAdd/booking/individual/$userId/';
  }

  static String getBookingsTeam({required String userId}) {
    return '$ipAdd/booking/team/$userId/';
  }
}

class UserUrls {
  static String getCurrentUser({required String token}) {
    return "$ipAdd/user/session/$token/";
  }

  static String adminLogin() {
    return "$ipAdd/adminlogin/";
  }

  static String getUserDetails({required String userId}) {
    return "$ipAdd/user/$userId/";
  }

  static String getUserRegex({required String like}) {
    return "$ipAdd/user/regex/$like/";
  }

  static String updateSessionToken(
      {required String userId, required String token}) {
    return "$ipAdd/user/session/$userId/$token/";
  }
}

class TeamUrls {
  static String getTeamDetails({required String teamId}) {
    return "$ipAdd/team/$teamId/";
  }

  static String addUserTeam({required String teamId, required String userId}) {
    return "$ipAdd/team/$teamId/adduser/$userId/";
  }

  static String reqUserTeam({required String teamId, required bool state}) {
    return "$ipAdd/team/req/$teamId/req/";
  }

  static String addAdmin({required String teamId, required String userId}) {
    return "$ipAdd/team/$teamId/makeadmin/$userId/";
  }

  static String getUserTeams({required String userId}) {
    return "$ipAdd/team/user/$userId/";
  }

  static String createTeam() {
    return '$ipAdd/team/';
  }
}

class RequestUrls {
  static String getUserRequest({required String userId}) {
    return "$ipAdd/request/user/$userId/";
  }

  static String makeEventRequest() {
    return '$ipAdd/request/';
  }

  static String makeAmmenityRequest() {
    return '$ipAdd/request/';
  }

  static String getRequest({required String userId}) {
    return "$ipAdd/request/userprovider/$userId/";
  }

  static String deleteRequest({required String reqId}) {
    return "$ipAdd/request/$reqId/";
  }
}
