import 'package:bookingsapp/src/models/event.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<Event> eventBooking = StateProvider<Event>((ref) {
  return Event.defaultEvent();
});
