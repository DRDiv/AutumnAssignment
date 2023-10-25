import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/src/models/user.dart';

class Amenity {
  String amenityId = "", amenityName = "", amenityPicture = "", recurrence = "";
  String amenityDate = "";
  String amenitySlot = "";

  User userProvider = User.defaultUser();
  Amenity(this.amenityId, this.amenityName, this.amenityPicture,
      this.recurrence, this.userProvider, this.amenityDate, this.amenitySlot);
  Amenity.defaultAmenity();
  Future<void> setData(
      Map<String, dynamic> responseData, String date, String slot) async {
    amenityId = responseData['amenityId'];
    amenityName = responseData['amenityName'];

    amenityPicture = responseData['amenityPicture'] ?? "";

    recurrence = responseData['recurrance'];
    amenityDate = date;
    amenitySlot = slot;
    userProvider = User.set(
        (await DatabaseQueries.getUserDetails(responseData['userProvider']))
            .data);
  }
}
