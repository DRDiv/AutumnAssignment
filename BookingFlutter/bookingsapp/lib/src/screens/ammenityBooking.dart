import 'package:bookingsapp/src/components/amenityDateSelector.dart';
import 'package:bookingsapp/src/components/amenityTimeSelector.dart';
import 'package:bookingsapp/src/components/responseIndicator.dart';
import 'package:bookingsapp/src/database/dbRequest.dart';
import 'package:bookingsapp/src/functions/format.dart';
import 'package:bookingsapp/src/functions/setters.dart';
import 'package:bookingsapp/src/providers/amenityBookingProvider.dart';

import 'package:bookingsapp/src/components/groupMembers.dart';
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
  bool _isLoading = true;
  DateTime _selectedDate = DateTime.now();
  String _selectedTime = '';
  Future<void> _loading() async {
    String time = await setDataAmenityBooking(widget.amenityId, ref);
    setState(() {
      _isLoading = false;
      _selectedTime = time;
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
                              child: (ref.read(amenityBooking).amenityPicture ==
                                      "")
                                  ? const Icon(
                                      Icons.category_sharp,
                                      color: Colors.black,
                                      size: 200,
                                    )
                                  : ClipRRect(
                                      child: Image.network(
                                      ref.read(amenityBooking).amenityPicture,
                                      fit: BoxFit.fitHeight,
                                    )),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              ref.read(amenityBooking).amenityName,
                              style: Theme.of(context).textTheme.displayLarge!,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              ref.read(amenityBooking).description,
                              style: Theme.of(context).textTheme.bodySmall!,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
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
                                    ref.read(amenityBooking).recurrence,
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
                                    ref.read(slots),
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
                          ref.read(userAmenity.notifier).state =
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return GroupMembers(
                                        context, ref.read(userAmenity));
                                  });
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_add),
                            SizedBox(width: 8),
                            Text("Add Group Members"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                          onPressed: () async {
                            dynamic response = await DatabaseQueriesRequest
                                .makeAmmenityRequest(
                                    ref.read(amenityBooking).amenityId,
                                    ref.read(userAmenity),
                                    parseStartTime(_selectedTime),
                                    _selectedDate);

                            showResponseDialog(context, response);
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
