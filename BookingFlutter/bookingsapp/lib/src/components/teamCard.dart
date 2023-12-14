import 'package:bookingsapp/src/components/loading.dart';
import 'package:bookingsapp/src/database/dbTeam.dart';
import 'package:bookingsapp/src/models/team.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:flutter/material.dart';

class TeamCard extends StatefulWidget {
  final Team teamData;
  final User userlogged;
  final Function rebuild;

  const TeamCard({
    Key? key,
    required this.teamData,
    required this.userlogged,
    required this.rebuild,
  }) : super(key: key);

  @override
  _TeamCardState createState() => _TeamCardState();
}

class _TeamCardState extends State<TeamCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        title: Text(
          widget.teamData.teamName,
          style: Theme.of(context).textTheme.bodyLarge!,
        ),
        leading: const Icon(Icons.group),
        trailing: widget.teamData.isReq[widget.userlogged.userId]
            ? SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        showLoadingDialog(context);
                        await DatabaseQueriesTeam.reqUserTeam(
                          widget.teamData.teamId,
                          widget.userlogged.userId,
                          true,
                        );
                        router.pop();
                        widget.rebuild();
                      },
                      icon: const Icon(Icons.check),
                    ),
                    IconButton(
                      onPressed: () async {
                        showLoadingDialog(context);
                        await DatabaseQueriesTeam.reqUserTeam(
                          widget.teamData.teamId,
                          widget.userlogged.userId,
                          false,
                        );
                        router.pop();
                        widget.rebuild();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              )
            : IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  router.push('/team/${widget.teamData.teamId}');
                },
              ),
      ),
    );
  }
}
