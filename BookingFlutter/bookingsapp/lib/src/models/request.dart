import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/src/models/ammenity.dart';
import 'package:bookingsapp/src/models/event.dart';

class Request {
  String requestId = "";
  int capacity = 0;
  String payment = "";
  String timeStart = "";
  String dateSlot = "";
  Event event = Event.defaultEvent();
  Amenity amenity = Amenity.defaultAmenity();
  List<String> individuals = [];
  String teamId = "";
  Request(this.requestId, this.capacity, this.payment, this.timeStart,
      this.event, this.amenity, this.teamId, this.individuals, this.dateSlot);
  Request.defaultRequest() {}
  Future<void> setData(Map requestindv) async {
    requestId = requestindv['requestId'];

    capacity = requestindv["capacity"];

    payment = requestindv["payment"] ?? "";
    if (requestindv["amenity"] != null) {
      timeStart = requestindv["timeStart"] ?? "";
      individuals = requestindv["indivduals"] ?? [];
      dateSlot = requestindv["dateSlot"] ?? "";
      await amenity.setData(
          (await DatabaseQueries.getAmmenityDetails(requestindv["amenity"]))
              .data,
          "",
          "");
    } else {
      teamId = requestindv["teamID"] ?? "";
      await event.setData(
          (await DatabaseQueries.getEventDetails(requestindv["event"])).data);
    }
  }

  String getName() {
    return (event.eventName == "") ? amenity.amenityName : event.eventName;
  }

  String getDateTime() {
    return (event.eventName == "") ? "$dateSlot $timeStart" : event.eventDate;
  }
}
