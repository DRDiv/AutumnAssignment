import 'dart:convert';

import 'package:bookingsapp/src/components/amenityDateSelector.dart';
import 'package:bookingsapp/src/components/amenityTimeSelector.dart';
import 'package:bookingsapp/src/database/dbAmenity.dart';
import 'package:bookingsapp/src/database/dbRequest.dart';
import 'package:bookingsapp/src/functions/format.dart';
import 'package:bookingsapp/src/models/ammenity.dart';

import 'package:bookingsapp/src/routing/routing.dart';
import 'package:bookingsapp/src/components/groupMembers.dart';
import 'package:bookingsapp/src/screens/transition.dart';
import 'package:bookingsapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AmenityBooking extends ConsumerStatefulWidget {
  final String amenityId;

  const AmenityBooking(this.amenityId, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AmenityBookingState();
}

class _AmenityBookingState extends ConsumerState<AmenityBooking> {
  Amenity _amenity = Amenity.defaultAmenity();
  final List<String> _slots = [];
  List<String> _users = [];
  bool _isLoading = true;
  DateTime _selectedDate = DateTime.now();
  String _selectedTime = '';
  Future<void> setData() async {
    Amenity a = Amenity.defaultAmenity();
    await a.setData(
        (await DatabaseQueriesAmenity.getAmenityDetails(widget.amenityId)).data,
        "",
        "");
    var response = await DatabaseQueriesAmenity.getAmenitySlot(a.amenityId);

    setState(() {
      _users.add(ref.read(userLogged).userId);
      for (var indv in response.data) {
        _slots.add(
            formatTimeRange(indv['amenitySlotStart'], indv['amenitySlotEnd']));
      }
      _amenity = a;

      _selectedTime = _slots[0];
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
            "Book Amenity",
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(color: Colors.white),
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 24, 8, 0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Center(
                            child: Container(
                              height: 250,
                              width: 250,
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              child: (_amenity.amenityPicture == "")
                                  ? const Icon(
                                      Icons.category_sharp,
                                      color: Colors.black,
                                      size: 200,
                                    )
                                  : ClipRRect(
                                      child: Image.network(
                                      _amenity.amenityPicture,
                                      fit: BoxFit.fitHeight,
                                    )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _amenity.amenityName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                              height: 200,
                              width: 300,
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black, // Border color
                                      width: 2.0, // Border width
                                    ),
                                  ),
                                  child: DateSelector(
                                    _amenity.recurrence,
                                    (date) {
                                      setState(() {
                                        _selectedDate = date;
                                      });
                                    },
                                  ))),
                          const SizedBox(height: 30),
                          SizedBox(
                              height: 200,
                              width: 300,
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black, // Border color
                                      width: 2.0, // Border width
                                    ),
                                  ),
                                  child: TimeSelector(
                                    _slots,
                                    (time) {
                                      setState(() {
                                        _selectedTime = time;
                                      });
                                    },
                                  ))),
                        ],
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                          onPressed: () async {
                            _users = await showDialog(
                                context: context,
                                builder: (context) {
                                  return GroupMembers(context, _users);
                                });
                          },
                          child: const Text("Add Group Members")),
                      const SizedBox(height: 100),
                      ElevatedButton(
                          onPressed: () async {
                            dynamic response = await DatabaseQueriesRequest
                                .makeAmmenityRequest(
                                    _amenity.amenityId,
                                    _users,
                                    parseStartTime(_selectedTime),
                                    _selectedDate);

                            // ignore: use_build_context_synchronously
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          json.decode(
                                              response.toString())['message'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              if (json.decode(response
                                                      .toString())['code'] ==
                                                  200) router.pop();
                                            },
                                            child: const Text("OK"))
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: const Text("Send Request"))
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
