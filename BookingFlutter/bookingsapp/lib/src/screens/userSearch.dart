import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bookingsapp/functions/get.dart';
import 'package:bookingsapp/src/assets/colors.dart';
import 'package:bookingsapp/src/assets/fonts.dart';
import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/src/models/user.dart';

class UserSearch extends ConsumerStatefulWidget {
  final context;
  List<User> users;
  final String teamId;

  UserSearch(this.context, this.users, this.teamId);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserSearchState();
}

class _UserSearchState extends ConsumerState<UserSearch> {
  TextEditingController _text = TextEditingController();
  String like = '';
  Map<String, bool> add = {};

  void rebuildWidget() {
    setState(() {});
  }

  Future<List<User>> setUsers() async {
    List<User> users = await getUsers(like, widget.users);
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      content: SizedBox(
        height: 400,
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: ColorSchemes.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onChanged: (text) {
                    setState(() {
                      like = text;
                    });
                  },
                  controller: _text,
                  decoration: InputDecoration(
                    hintText: 'Enter Username',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorSchemes.secondayColor),
                    ),
                  ),
                  cursorColor: ColorSchemes.primaryColor,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<User>>(
                future: setUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "No Users Found",
                        style: FontsCustom.bodyBigText,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () async {
                            add[snapshot.data![index].userId] =
                                !(add[snapshot.data![index].userId] ?? false);
                            rebuildWidget();
                          },
                          leading: CircleAvatar(
                            backgroundColor: ColorSchemes.backgroundColor,
                            radius: 15.0,
                            child: (snapshot.data![index].data['person'] ==
                                        null ||
                                    snapshot.data![index].data['person']
                                            ['displayPicture'] ==
                                        null)
                                ? const Icon(Icons.person,
                                    size: 30, color: Colors.black)
                                : ClipOval(
                                    child: Image.network(
                                      "https://channeli.in/" +
                                          snapshot.data![index].data['person']
                                              ['displayPicture'],
                                      width: 30.0,
                                      height: 30.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          title: Text(snapshot.data![index].userName),
                          trailing: (add[snapshot.data![index].userId] ?? false)
                              ? Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              : Icon(Icons.add, color: Colors.red),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorSchemes.secondayColor,
                textStyle: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                for (var userInd in add.keys) {
                  if (add[userInd]!) {
                    await DatabaseQueries.addUserTeam(widget.teamId, userInd);
                  }
                }

                Navigator.of(widget.context).pop("confirmed");
              },
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
