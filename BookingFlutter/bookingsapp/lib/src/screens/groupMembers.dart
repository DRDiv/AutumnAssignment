import 'package:bookingsapp/src/assets/colors.dart';
import 'package:bookingsapp/src/assets/fonts.dart';
import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GroupMembers extends ConsumerStatefulWidget {
  final context;
  final List<String> users;

  const GroupMembers(this.context, this.users);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupMembersState();
}

class _GroupMembersState extends ConsumerState<GroupMembers> {
  TextEditingController _text = TextEditingController();
  String like = '';
  Map<String, bool> add = {};

  Future<List<User>> getUsers(String like) async {
    var response = await DatabaseQueries.getUserRegex(like);
    List<User> users = [];

    for (var indv in response.data) {
      if (indv['userId'] != ref.read(userLogged).userId) {
        User temp = User.set(indv);
        if (!temp.ammenityProvider) users.add(temp);
      }
    }

    return users;
  }

  void rebuildWidget() {
    setState(() {});
  }

  void initState() {
    super.initState();
    setState(() {
      for (var indv in widget.users) {
        add[indv] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      content: SizedBox(
        height: 400,
        width: 200,
        child: Column(
          children: [
            Container(
              color: ColorSchemes.backgroundColor,
              child: TextFormField(
                onChanged: (text) {
                  setState(() {
                    like = text;
                  });
                },
                controller: _text,
                decoration: InputDecoration(
                  hintText: 'Enter Username',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorSchemes.primaryColor),
                  ),
                ),
                cursorColor: ColorSchemes.primaryColor,
              ),
            ),
            FutureBuilder<List<User>>(
              future: getUsers(like),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 40, 8, 0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 40, 8, 0),
                    child: Center(
                      child: Text(
                        "No Users Found",
                        style: FontsCustom.bodyBigText,
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () async {
                            add[snapshot.data![index].userId] =
                                !(add[snapshot.data![index].userId] ?? false);
                            print(add);

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
                                    ))),
                          title: Text(snapshot.data![index].userName),
                          trailing: (add[snapshot.data![index].userId] ?? false)
                              ? Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              : Icon(Icons.add, color: Colors.red),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(ColorSchemes
                      .primaryColor), // Change this color to your desired background color
                ),
                onPressed: () async {
                  List<String> userReturn = [];
                  print(add);
                  for (var userInd in add.keys) {
                    if (add[userInd]! && !userReturn.contains(userInd)) {
                      userReturn.add(userInd);
                    }
                  }
                  print(userReturn);
                  Navigator.of(widget.context).pop(userReturn);
                },
                child: Text('Confirm')),
          ],
        ),
      ),
    );
  }
}
