import 'package:bookingsapp/database/database.dart';
import 'package:bookingsapp/models/user.dart';

class Amenity {
  String amenityId = "",
      amenityName = "",
      amenityPicture = "",
      amenityDate = "",
      amenityDateEnd = "",
      recurrence = "";
  int capacity = 0;
  User userProvider = User.defaultUser();
  Amenity(
      this.amenityId,
      this.amenityName,
      this.amenityDate,
      this.amenityDateEnd,
      this.amenityPicture,
      this.recurrence,
      this.capacity,
      this.userProvider);
  Amenity.defaultAmenity();
  Future<void> setData(Map<String, dynamic> responseData) async {
    amenityId = responseData['amenityId'];
    amenityName = responseData['amenityName'];
    amenityPicture = responseData['amenityPicture'] ?? "";
    amenityDate = responseData['amenityDate'];
    amenityDateEnd = responseData['amenityDateEnd'];
    recurrence = responseData['recurrence'];
    capacity = responseData['capacity'];
    userProvider = User.set(
        (await DatabaseQueries.getUserDetails(responseData['userProvider']))
            .data);
  }
}
