// ignore_for_file: file_names

import 'package:bookingsapp/src/components/bottomAppBar.dart';
import 'package:bookingsapp/src/database/dbRequest.dart';
import 'package:bookingsapp/src/database/dbUser.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:bookingsapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class UserProfile extends ConsumerStatefulWidget {
  String userId;
  UserProfile(this.userId, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {
  User _userCurrent = User.defaultUser();
  bool _isLoading = true;
  Future<void> setUser() async {
    User userTemp = User.set(
        (await DatabaseQueriesUser.getUserDetails(widget.userId)).data);
    setState(() {
      _userCurrent = userTemp;
      _isLoading = false;
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
                context.go('/home');
              },
            ),
            title: Text(
              "Profile",
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: Colors.white),
            ),
            actions: [
              IconButton(
                  tooltip: 'Logout',
                  onPressed: () async {
                    const storage = FlutterSecureStorage();
                    await storage.deleteAll();
                    // ignore: use_build_context_synchronously
                    context.go('/login');
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ))
            ],
          ),
          body: Container(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 24.0, 8, 24),
                      child: Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                radius: 40.0,
                                child: (_userCurrent.data['person'] == null ||
                                        _userCurrent.data['person']
                                                ['displayPicture'] ==
                                            null)
                                    ? const Icon(Icons.person,
                                        size: 80, color: Colors.black)
                                    : ClipOval(
                                        child: Image.network(
                                        "https://channeli.in/${_userCurrent.data['person']['displayPicture']}",
                                        width: 80.0,
                                        height: 80.0,
                                        fit: BoxFit.cover,
                                      ))),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _userCurrent.userName,
                                style:
                                    Theme.of(context).textTheme.displaySmall!,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _userCurrent.data['student']['enrolmentNumber'],
                                style: Theme.of(context).textTheme.bodySmall!,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _userCurrent.data['student']['branch name'],
                                style: Theme.of(context).textTheme.bodySmall!,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Year: ${_userCurrent.data['student']['currentYear']}",
                                style: Theme.of(context).textTheme.bodySmall!,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Penalties: ${_userCurrent.penalties}",
                                style: Theme.of(context).textTheme.bodySmall!,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
          bottomNavigationBar: BottomAppBarUser(context, _userCurrent)),
    );
  }
}
