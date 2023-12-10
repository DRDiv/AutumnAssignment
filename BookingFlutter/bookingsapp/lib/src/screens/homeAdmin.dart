import 'package:bookingsapp/src/components/bottomAppBar.dart';
import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/src/models/request.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:bookingsapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeAdmin extends ConsumerStatefulWidget {
  const HomeAdmin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeAdminState();
}

class _HomeAdminState extends ConsumerState<HomeAdmin> {
  final List<Requests> _requests = [];
  bool _isLoading = true;
  Future<void> setData() async {
    List<dynamic> reponse =
        (await DatabaseQueries.getRequest(ref.read(userLogged).userId)).data;
    for (var requestindv in reponse) {
      Requests request = Requests.defaultRequest();
      await request.setData(requestindv);
      setState(() {
        _requests.add(request);
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "BOOKING\$",
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _isLoading = true;
              _requests.clear();
            });

            await setData();
          },
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ((_requests.isEmpty)
                  ? Center(
                      child: Text(
                      "No Aprrovals Pending!!",
                      style: Theme.of(context).textTheme.bodyLarge!,
                    ))
                  : ListView.builder(
                      itemCount: _requests.length,
                      itemBuilder: (context, index) {
                        final request = _requests[index];

                        return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) async {
                            if (direction == DismissDirection.endToStart) {
                              await DatabaseQueries.deleteRequest(
                                  request.requestId);
                              setState(() {
                                _requests.removeAt(index);
                              });
                            } else if (direction ==
                                DismissDirection.startToEnd) {
                              await DatabaseQueries.requestToBooking(
                                  request.requestId);
                              setState(() {
                                _requests.removeAt(index);
                              });
                            }
                          },
                          secondaryBackground: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16.0),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          background: Container(
                            color: Colors.green,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 16.0),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                            ),
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              onTap: () {
                                if (request.payment != "") {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Center(
                                              child: Image.network(
                                                  request.payment)),
                                        );
                                      });
                                }
                              },
                              title: Text(request.getName()),
                              subtitle: Text(request.getDateTime()),
                              trailing:
                                  Text("NO OF BOOKINGS : ${request.capacity}"),
                            ),
                          ),
                        );
                      },
                    )),
        ),
        bottomNavigationBar: BottomAppBarAdmin(context, ref),
      ),
    );
  }
}
