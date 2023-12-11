import 'package:bookingsapp/src/database/dbUser.dart';
import 'package:bookingsapp/src/functions/format.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:bookingsapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupMembers extends ConsumerStatefulWidget {
  final BuildContext context;
  final List<String> users;

  const GroupMembers(this.context, this.users, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupMembersState();
}

class _GroupMembersState extends ConsumerState<GroupMembers> {
  final TextEditingController _text = TextEditingController();
  String _like = '';
  final Map<String, bool> _add = {};

  void rebuildWidget() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      for (var indv in widget.users) {
        _add[indv] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme(),
      child: AlertDialog(
        scrollable: true,
        content: SizedBox(
          height: 400,
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (text) {
                      setState(() {
                        _like = text;
                      });
                    },
                    controller: _text,
                    decoration: const InputDecoration(
                      hintText: 'Enter Username',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<User>>(
                  future: getUsersGroup(_like, ref.read(userLogged).userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.warning,
                              size: 50, // Adjust the size of the icon as needed
                              color: Colors
                                  .red, // Adjust the color of the icon as needed
                            ),
                            const SizedBox(
                                height:
                                    10), // Add some spacing between the icon and the text
                            Text(
                              "No Users Found",
                              style: Theme.of(context).textTheme.bodyLarge!,
                            ),
                          ],
                        ),
                      ));
                    } else {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () async {
                                _add[snapshot.data![index].userId] =
                                    !(_add[snapshot.data![index].userId] ??
                                        false);

                                rebuildWidget();
                              },
                              leading: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  radius: 15.0,
                                  child: (snapshot.data![index]
                                                  .data['person'] ==
                                              null ||
                                          snapshot.data![index].data['person']
                                                  ['displayPicture'] ==
                                              null)
                                      ? const Icon(Icons.person,
                                          size: 30, color: Colors.black)
                                      : ClipOval(
                                          child: Image.network(
                                          "https://channeli.in/${snapshot.data![index].data['person']['displayPicture']}",
                                          width: 30.0,
                                          height: 30.0,
                                          fit: BoxFit.cover,
                                        ))),
                              title: Text(snapshot.data![index].userName),
                              trailing: (_add[snapshot.data![index].userId] ??
                                      false)
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  : const Icon(Icons.add, color: Colors.red),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    List<String> userReturn = [];

                    for (var userInd in _add.keys) {
                      if (_add[userInd]! && !userReturn.contains(userInd)) {
                        userReturn.add(userInd);
                      }
                    }

                    Navigator.of(widget.context).pop(userReturn);
                  },
                  child: const Text('Confirm')),
            ],
          ),
        ),
      ),
    );
  }
}
