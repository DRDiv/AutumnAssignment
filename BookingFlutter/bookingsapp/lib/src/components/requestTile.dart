import 'package:bookingsapp/src/database/dbBooking.dart';
import 'package:bookingsapp/src/database/dbRequest.dart';
import 'package:bookingsapp/src/models/request.dart';
import 'package:bookingsapp/src/providers/requestAdminProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget requestTile(
    BuildContext context, WidgetRef ref, int index, Requests request) {
  return Dismissible(
    key: UniqueKey(),
    onDismissed: (direction) async {
      if (direction == DismissDirection.endToStart) {
        await DatabaseQueriesRequest.deleteRequest(request.requestId);

        ref.read(requestAdmin).removeAt(index);
      } else if (direction == DismissDirection.startToEnd) {
        await DatabaseQueriesBookings.requestToBooking(request.requestId);

        ref.read(requestAdmin).removeAt(index);
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
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
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
                    child: Image.network(request.payment),
                  ),
                );
              },
            );
          }
        },
        title: Text(request.getName()),
        subtitle: Text(request.getDateTime()),
        trailing: Text("NO OF BOOKINGS : ${request.capacity}"),
      ),
    ),
  );
}
