import 'package:bookingsapp/src/models/user.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

BottomAppBar BottomAppBarUser(BuildContext context, User userlogged) {
  return BottomAppBar(
      child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Expanded(
        child: IconButton(
            tooltip: 'Home',
            onPressed: () {
              context.go("/home");
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
              context.go("/team");
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
