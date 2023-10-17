import 'package:bookingsapp/assets/colors.dart';
import 'package:bookingsapp/assets/fonts.dart';
import 'package:bookingsapp/database/database.dart';
import 'package:bookingsapp/main.dart';
import 'package:bookingsapp/models/user.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WidgetCustom extends StatefulWidget {
  User userlogged;
  String ipAdd;
  WidgetCustom(this.userlogged, this.ipAdd);

  @override
  State<WidgetCustom> createState() => _WidgetCustomState();
}

class _WidgetCustomState extends State<WidgetCustom> {
  late Future<List<String>> dataIndvFuture;

  @override
  void initState() {
    super.initState();
    setState(() {
      dataIndvFuture = getTeams();
    });
  }

  Future<List<String>> getTeams() async {
    var dio = Dio();
    try {
      var response = await dio
          .get('${widget.ipAdd}/team/user/${widget.userlogged.userId}/');

      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data;

        List<String> typedData = [];

        for (var responseInd in response.data) {
          typedData.add(responseInd['teamName']);
        }

        return typedData;
      }
    } catch (e) {
      print(e);
    }

    return [];
  }

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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
        child: FutureBuilder<List<String>>(
            future: dataIndvFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Center(
                  child: Text("An error occurred."),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "No Bookings Found",
                    style: FontsCustom.bodyBigText,
                  ),
                );
              } else {
                List<String> dataIndv = snapshot.data ?? [];
                return ListView.builder(
                    itemCount: dataIndv.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: ColorCustomScheme.tileColor),
                            ),
                            child: TextButton(
                              child: Text(
                                dataIndv[index],
                                style: FontsCustom.bodyBigText,
                              ),
                              onPressed: () {},
                            )),
                      );
                    });
              }
            }),
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

class TeamPage extends ConsumerStatefulWidget {
  const TeamPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeamPageState();
}

class _TeamPageState extends ConsumerState<TeamPage> {
  @override
  Widget build(BuildContext context) {
    User userlogged = ref.read(userLogged);
    String ipAdd = ref.read(ip);
    return WidgetCustom(userlogged, ipAdd);
  }
}
