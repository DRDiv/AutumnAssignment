import 'package:bookingsapp/src/models/user.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: non_constant_identifier_names
BottomAppBar BottomAppBarUser(BuildContext context, User userlogged) {
  return BottomAppBar(
      child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Expanded(
        child: IconButton(
            tooltip: 'Home',
            onPressed: () {
              router.go("/home");
            },
            icon: Column(
              children: [
                const Icon(
                  Icons.home,
                ),
                Text(
                  'Home',
                  style: Theme.of(context).textTheme.labelSmall,
                )
              ],
            )),
      ),
      Expanded(
        child: IconButton(
            tooltip: 'Your Teams',
            onPressed: () {
              router.push("/team");
            },
            icon: Column(
              children: [
                const Icon(
                  Icons.people,
                ),
                Text(
                  'Teams',
                  style: Theme.of(context).textTheme.labelSmall,
                )
              ],
            )),
      ),
      Expanded(
        child: IconButton(
            tooltip: 'User Profile',
            onPressed: () {
              router.push("/userprofile/${userlogged.userId}");
            },
            icon: Column(
              children: [
                const Icon(
                  Icons.person,
                ),
                Text(
                  'Profile',
                  style: Theme.of(context).textTheme.labelSmall,
                )
              ],
            )),
      )
    ],
  ));
}

// ignore: non_constant_identifier_names
BottomAppBar BottomAppBarAdmin(BuildContext context, WidgetRef ref) {
  return BottomAppBar(
      child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Expanded(
        child: IconButton(
            onPressed: () {
              router.go("/homeAdmin");
            },
            icon: Column(
              children: [
                const Icon(
                  Icons.home,
                ),
                Text(
                  'Home',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            )),
      ),
      Expanded(
        child: IconButton(
            onPressed: () {
              router.push("/eventAdmin");
            },
            icon: Column(
              children: [
                const Icon(
                  Icons.event,
                ),
                Text(
                  'Event',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            )),
      ),
      Expanded(
        child: IconButton(
            onPressed: () {
              router.push("/amenityAdmin");
            },
            icon: Column(
              children: [
                const Icon(
                  Icons.local_activity,
                ),
                Text(
                  'Amenity',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            )),
      ),
      Expanded(
        child: IconButton(
            onPressed: () {
              router.go("/adminManage");
            },
            icon: Column(
              children: [
                const Icon(
                  Icons.admin_panel_settings,
                ),
                Text(
                  'Manage',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            )),
      ),
    ],
  ));
}
