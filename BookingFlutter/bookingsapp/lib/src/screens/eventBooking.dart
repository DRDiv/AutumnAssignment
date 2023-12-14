import 'dart:convert';
import 'dart:io';

import 'package:bookingsapp/src/database/dbEvent.dart';
import 'package:bookingsapp/src/database/dbRequest.dart';
import 'package:bookingsapp/src/functions/format.dart';
import 'package:bookingsapp/src/models/event.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:bookingsapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventBooking extends ConsumerStatefulWidget {
  final String eventId;
  final String teamId;
  const EventBooking(this.eventId, this.teamId, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventBookingState();
}

class _EventBookingState extends ConsumerState<EventBooking> {
  Event _event = Event.defaultEvent();
  bool _paymentAttached = false;
  bool _isLoading = true;
  File? _image;
  Future<void> setData() async {
    Event e = Event.defaultEvent();
    await e.setData(
        (await DatabaseQueriesEvent.getEventDetails(widget.eventId)).data);
    setState(() {
      _event = e;
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
                              child: (_event.eventPicture == "")
                                  ? const Icon(
                                      Icons.category_sharp,
                                      color: Colors.black,
                                      size: 100,
                                    )
                                  : ClipRRect(
                                      child: Image.network(
                                      _event.eventPicture,
                                      fit: BoxFit.fill,
                                    )),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              _event.eventName,
                              style: Theme.of(context).textTheme.displayLarge!,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _event.description,
                              style: Theme.of(context).textTheme.bodyLarge!,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          (_event.payment > 0)
                              ? InkWell(
                                  onTap: () async {
                                    File? eventPictureGet = await getImage(ref);
                                    if (eventPictureGet != null) {
                                      setState(() {
                                        _image = eventPictureGet;
                                        _paymentAttached = true;
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: _paymentAttached
                                          ? Colors
                                              .green // Use a success color when payment is attached
                                          : Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.attach_money,
                                            color: Colors.white),
                                        const SizedBox(width: 8),
                                        Text(
                                          _paymentAttached
                                              ? "Payment Attached"
                                              : "Attach Payment Screenshot",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const Row(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: () async {
                            if (_event.payment > 0 && _image == null) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: SizedBox(
                                      height: 75,
                                      width: 100,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'Attach Payment',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!,
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                router.pop();
                                              },
                                              child: const Text("OK"))
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                              return;
                            }

                            dynamic response =
                                await DatabaseQueriesRequest.makeEventRequest(
                                    widget.eventId, widget.teamId, _image);

                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: SizedBox(
                                    height: 75,
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
                                              router.pop();
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
