import 'package:bookingsapp/src/database/dbRequest.dart';
import 'package:bookingsapp/src/database/dbTeam.dart';
import 'package:bookingsapp/src/database/dbUser.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class TeamMembers extends StatefulWidget {
  List<User> members;
  Map<String, dynamic> isAdmin;
  Map<String, dynamic> isReq;
  User userlogged;
  String teamId;
  Function rebuild;
  TeamMembers(this.members, this.isAdmin, this.isReq, this.userlogged,
      this.teamId, this.rebuild,
      {super.key});

  @override
  State<TeamMembers> createState() => TeamMembersState();
}

class TeamMembersState extends State<TeamMembers> {
  @override
  Widget build(BuildContext context) {
    final reversedMembers = widget.members.reversed.toList();
    return ListView.builder(
        itemCount: reversedMembers.length,
        itemBuilder: (context, index) {
          User user = reversedMembers[index];

          return ListTile(
            leading: CircleAvatar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                radius: 20.0,
                child: (user.data['person'] == null ||
                        user.data['person']['displayPicture'] == null)
                    ? const Icon(Icons.person, size: 40, color: Colors.black)
                    : ClipOval(
                        child: Image.network(
                        "https://channeli.in/${user.data['person']['displayPicture']}",
                        width: 40.0,
                        height: 40.0,
                        fit: BoxFit.cover,
                      ))),
            title: TextButton(
                onPressed: () {
                  final router = GoRouter.of(context);
                  router.push("/userProfile/${user.userId}");
                },
                child: Text(
                  (user.userName +
                      ((user.userId == widget.userlogged.userId)
                          ? " (You)"
                          : "") +
                      ((widget.isReq[user.userId]) ? " (Req)" : "")),
                )),
            trailing: (widget.isAdmin[widget.userlogged.userId] &&
                    !widget.isAdmin[user.userId])
                ? IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: ElevatedButton(
                                  onPressed: () async {
                                    await DatabaseQueriesTeam.addAdmin(
                                        widget.teamId, user.userId);
                                    widget.rebuild();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Confirm')),
                              backgroundColor: Theme.of(context).primaryColor,
                            );
                          });
                    },
                    icon: const Icon(Icons.add))
                : const Text(''),
          );
        });
  }
}
