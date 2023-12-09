import 'package:bookingsapp/src/components/bottomAppBar.dart';
import 'package:bookingsapp/src/components/individualTab.dart';
import 'package:bookingsapp/src/components/requestTab.dart';
import 'package:bookingsapp/src/components/teamTab.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:bookingsapp/src/components/amenitySearch.dart';
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

class _TabWidgetState extends ConsumerState<TabWidget>
    with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    setState(() {
      tabController = TabController(length: 3, vsync: this);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: AppTheme.lightTheme(),
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
              appBar: AppBar(
                title: Text(
                  "BOOKING\$",
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(color: Colors.white),
                ),
                centerTitle: true,
                bottom: TabBar(
                  controller: tabController,

                  tabs: const [
                    Tab(text: 'Individual'),
                    Tab(text: 'Team'),
                    Tab(text: 'Requests')
                  ],
                  // indicator: BoxDecoration(color: ColorSchemes.secondayColor),
                ),
              ),
              body: TabBarView(
                controller: tabController,
                children: [
                  IndividualTab(widget.userlogged),
                  TeamTab(widget.userlogged),
                  RequestTab(widget.userlogged)
                ],
              ),
              bottomNavigationBar:
                  BottomAppBarUser(context, ref.read(userLogged)),
              floatingActionButton: FloatingActionButton(
                tooltip: 'Book an Amenity',
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AmenityAlertBox();
                      });
                },
                child: const Icon(Icons.add),
              )),
        ));
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<dynamic> dataIndv = [];
  Map dataTeam = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User userlogged = ref.read(userLogged);

    return TabWidget(userlogged);
  }
}
