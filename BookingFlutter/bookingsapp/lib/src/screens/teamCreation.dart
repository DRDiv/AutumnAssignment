import 'package:bookingsapp/src/database/dbTeam.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:bookingsapp/src/components/groupMembers.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:bookingsapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamCreation extends ConsumerStatefulWidget {
  const TeamCreation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeamCreationState();
}

class _TeamCreationState extends ConsumerState<TeamCreation> {
  final TextEditingController _text = TextEditingController();
  List<String> _users = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      _users.add(ref.read(userLogged).userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Create Team",
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter Team Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    controller: _text,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      _users = await showDialog(
                        context: context,
                        builder: (context) {
                          return GroupMembers(context, _users);
                        },
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_add),
                        SizedBox(width: 8),
                        Text("Add Team Members"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      if (_text.text.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Team Name is Required"),
                        ));

                        return;
                      }

                      await DatabaseQueriesTeam.createTeam(
                        _text.text,
                        _users,
                        ref.read(userLogged).userId,
                      );
                      router.pop();
                    },
                    child: const Text('Create Team'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
