import 'package:bookingsapp/src/components/amenityTab.dart';
import 'package:bookingsapp/src/components/bottomAppBar.dart';
import 'package:bookingsapp/src/components/eventTab.dart';
import 'package:bookingsapp/src/functions/format.dart';

import 'package:bookingsapp/src/models/user.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:bookingsapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class TabWidget extends ConsumerStatefulWidget {
  User userlogged;

  TabWidget(this.userlogged, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TabWidgetState();
}

class _TabWidgetState extends ConsumerState<TabWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme(),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Manage",
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(color: Colors.white),
              ),
              centerTitle: true,
              bottom: const TabBar(
                tabs: [Tab(text: 'Amenity'), Tab(text: 'Event')],
              ),
            ),
            body: TabBarView(
              children: [
                AmenityTab(widget.userlogged),
                EventTab(widget.userlogged),
              ],
            ),
            bottomNavigationBar: BottomAppBarAdmin(context, ref)),
      ),
    );
  }
}

class AdminManage extends ConsumerStatefulWidget {
  const AdminManage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminManageState();
}

class _AdminManageState extends ConsumerState<AdminManage> {
  void method() async {
    String s = await getSessionToken();
    print(s);
  }

  @override
  void initState() {
    super.initState();
    method();
  }

  @override
  Widget build(BuildContext context) {
    User userlogged = ref.read(userLogged);

    return TabWidget(userlogged);
  }
}
