import 'package:bookingsapp/src/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<User> userLogged =
    StateProvider<User>((ref) => User.defaultUser());
