import 'package:bookingsapp/src/models/request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<List<Requests>> requestAdmin =
    StateProvider<List<Requests>>((ref) => []);
