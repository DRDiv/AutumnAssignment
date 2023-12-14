import 'package:bookingsapp/src/components/bottomAppBar.dart';
import 'package:bookingsapp/src/components/individualTab.dart';
import 'package:bookingsapp/src/components/requestTab.dart';
import 'package:bookingsapp/src/components/teamTab.dart';
import 'package:bookingsapp/src/components/amenitySearch.dart';
import 'package:bookingsapp/src/providers/userLoggedProvider.dart';
import 'package:bookingsapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabWidget extends ConsumerStatefulWidget {
  const TabWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TabWidgetState();
}

class _TabWidgetState extends ConsumerState<TabWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    setState(() {
      _tabController = TabController(length: 3, vsync: this);
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
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Individual'),
                    Tab(text: 'Team'),
                    Tab(text: 'Requests')
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  IndividualTab(ref.read(userLogged)),
                  TeamTab(ref.read(userLogged)),
                  RequestTab(ref.read(userLogged))
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
                        return const AmenityAlertBox();
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
  @override
  Widget build(BuildContext context) {
    return const TabWidget();
  }
}
