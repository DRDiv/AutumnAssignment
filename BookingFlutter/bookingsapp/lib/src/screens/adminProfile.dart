// Import necessary packages and files
import 'package:bookingsapp/src/models/user.dart';
import 'package:bookingsapp/src/providers/userLoggedProvider.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:bookingsapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// AdminProfile class
class AdminProfile extends ConsumerStatefulWidget {
  AdminProfile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminProfileState();
}

// _AdminProfileState class
class _AdminProfileState extends ConsumerState<AdminProfile> {
  late User _userCurrent;

  Future<void> setUser() async {
    setState(() {
      _userCurrent = ref.read(userLogged);
    });
  }

  @override
  void initState() {
    super.initState();
    setUser();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              router.go('/homeAdmin');
            },
          ),
          title: Text(
            "Profile",
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(color: Colors.white),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 24.0, 8, 24),
                    child: Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            radius: 40.0,
                            child: const Icon(Icons.person,
                                size: 80, color: Colors.black),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _userCurrent.userName,
                              style: Theme.of(context).textTheme.displaySmall!,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              _userCurrent.data['email'] ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: Colors.black38),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    const storage = FlutterSecureStorage();
                    await storage.deleteAll();
                    router.go('/login');
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 8.0),
                      Text('Logout'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
