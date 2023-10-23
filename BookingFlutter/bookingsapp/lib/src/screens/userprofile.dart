import 'package:bookingsapp/src/assets/colors.dart';
import 'package:bookingsapp/src/assets/fonts.dart';
import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserProfile extends ConsumerStatefulWidget {
  String userId;
  UserProfile(this.userId);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {
  User userCurrent = User.defaultUser();
  bool isLoading = true;
  Future<void> setUser() async {
    User userTemp =
        User.set((await DatabaseQueries.getUserDetails(widget.userId)).data);
    setState(() {
      userCurrent = userTemp;
      isLoading = false;
    });
    print(userCurrent.data);
  }

  void initState() {
    super.initState();
    setUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            final router = GoRouter.of(context);
            router.pop();
          },
        ),
        backgroundColor: ColorCustomScheme.appBarColor,
        title: Text(
          "BOOKING\$",
          style: FontsCustom.heading,
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 24.0, 8, 24),
                child: Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                          backgroundColor: ColorCustomScheme.backgroundColor,
                          radius: 40.0,
                          child: (userCurrent.data['person'] == null ||
                                  userCurrent.data['person']
                                          ['displayPicture'] ==
                                      null)
                              ? const Icon(Icons.person,
                                  size: 80, color: Colors.black)
                              : ClipOval(
                                  child: Image.network(
                                  "https://channeli.in/" +
                                      userCurrent.data['person']
                                          ['displayPicture'],
                                  width: 80.0,
                                  height: 80.0,
                                  fit: BoxFit.cover,
                                ))),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          userCurrent.userName,
                          style: FontsCustom.bodyHeading,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          userCurrent.data['student']['enrolmentNumber'],
                          style: FontsCustom.bodySmallText,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          userCurrent.data['student']['branch name'],
                          style: FontsCustom.bodySmallText,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Year: " +
                              userCurrent.data['student']['currentYear']
                                  .toString(),
                          style: FontsCustom.bodySmallText,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Penalties: " + userCurrent.penalties.toString(),
                          style: FontsCustom.bodySmallText,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: BottomAppBar(
          color: ColorCustomScheme.appBarColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: IconButton(
                    onPressed: () {
                      context.go("/home");
                    },
                    icon: Icon(
                      Icons.home,
                      color: ColorCustomScheme.backgroundColor,
                    )),
              ),
              Expanded(
                child: IconButton(
                    onPressed: () {
                      context.go("/team");
                    },
                    icon: Icon(
                      Icons.people,
                      color: ColorCustomScheme.backgroundColor,
                    )),
              )
            ],
          )),
    );
  }
}
