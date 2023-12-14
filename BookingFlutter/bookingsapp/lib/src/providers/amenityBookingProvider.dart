import 'package:bookingsapp/src/models/ammenity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<Amenity> amenityBooking = StateProvider<Amenity>((ref) {
  return Amenity.defaultAmenity();
});
StateProvider<List<String>> userAmenity =
    StateProvider<List<String>>((ref) => []);
StateProvider<List<String>> slots = StateProvider<List<String>>((ref) => []);
