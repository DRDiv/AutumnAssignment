import 'package:bookingsapp/database/database.dart';
import 'package:bookingsapp/models/user.dart';

class Amenity {
  String amenityId = "", amenityName = "", amenityPicture = "", recurrence = "";

  User userProvider = User.defaultUser();
  Amenity(this.amenityId, this.amenityName, this.amenityPicture,
      this.recurrence, this.userProvider);
  Amenity.defaultAmenity();
  Future<void> setData(Map<String, dynamic> responseData) async {
    amenityId = responseData['amenityId'];
    amenityName = responseData['amenityName'];

    amenityPicture = responseData['amenityPicture'] ?? "";

    recurrence = responseData['recurrance'];

    userProvider = User.set(
        (await DatabaseQueries.getUserDetails(responseData['userProvider']))
            .data);
  }
}
