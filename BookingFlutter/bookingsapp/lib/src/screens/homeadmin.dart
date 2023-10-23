import 'package:bookingsapp/src/assets/colors.dart';
import 'package:bookingsapp/src/assets/fonts.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class HomeAdmin extends ConsumerStatefulWidget {
  const HomeAdmin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeAdminState();
}

class _HomeAdminState extends ConsumerState<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorCustomScheme.appBarColor,
        title: Text(
          "BOOKING\$",
          style: FontsCustom.heading,
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomAppBar(
          color: ColorCustomScheme.appBarColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: IconButton(
                    onPressed: () {
                      context.go("/homeAdmin");
                    },
                    icon: Icon(
                      Icons.home,
                      color: ColorCustomScheme.backgroundColor,
                    )),
              ),
              Expanded(
                child: IconButton(
                    onPressed: () {
                      router.push("/eventAdmin");
                    },
                    icon: Icon(
                      Icons.event,
                      color: ColorCustomScheme.backgroundColor,
                    )),
              ),
              Expanded(
                child: IconButton(
                    onPressed: () {
                      router.push("/amenityAdmin");
                    },
                    icon: Icon(
                      Icons.local_activity,
                      color: ColorCustomScheme.backgroundColor,
                    )),
              ),
              Expanded(
                child: IconButton(
                    onPressed: () async {
                      final storage = new FlutterSecureStorage();
                      await storage.deleteAll();
                      context.go("/login");
                    },
                    icon: Icon(
                      Icons.logout,
                      color: ColorCustomScheme.backgroundColor,
                    )),
              )
            ],
          )),
    );
  }
}
