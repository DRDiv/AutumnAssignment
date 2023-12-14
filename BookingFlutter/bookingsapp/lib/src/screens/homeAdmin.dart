import 'package:bookingsapp/src/components/bottomAppBar.dart';
import 'package:bookingsapp/src/database/dbBooking.dart';
import 'package:bookingsapp/src/database/dbRequest.dart';
import 'package:bookingsapp/src/functions/setters.dart';
import 'package:bookingsapp/src/providers/requestAdminProvider.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:bookingsapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeAdmin extends ConsumerStatefulWidget {
  const HomeAdmin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeAdminState();
}

class _HomeAdminState extends ConsumerState<HomeAdmin> {
  bool _isLoading = true;
  Future<void> _loading() async {
    await setRequestData(ref);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loading();
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
          actions: [
            IconButton(
                onPressed: () {
                  router.go("/adminProfile");
                },
                icon: const Icon(Icons.person))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _isLoading = true;
              ref.read(requestAdmin).clear();
            });

            await _loading();
          },
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ((ref.read(requestAdmin).isEmpty)
                  ? Center(
                      child: Text(
                      "No Aprrovals Pending!!",
                      style: Theme.of(context).textTheme.bodyLarge!,
                    ))
                  : ListView.builder(
                      itemCount: ref.read(requestAdmin).length,
                      itemBuilder: (context, index) {
                        final request = ref.read(requestAdmin)[index];

                        return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) async {
                            if (direction == DismissDirection.endToStart) {
                              await DatabaseQueriesRequest.deleteRequest(
                                  request.requestId);
                              setState(() {
                                ref.read(requestAdmin).removeAt(index);
                              });
                            } else if (direction ==
                                DismissDirection.startToEnd) {
                              await DatabaseQueriesBookings.requestToBooking(
                                  request.requestId);
                              setState(() {
                                ref.read(requestAdmin).removeAt(index);
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
