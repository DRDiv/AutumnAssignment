import 'package:bookingsapp/src/database/dbAmenity.dart';
import 'package:bookingsapp/src/models/user.dart';
import 'package:flutter/material.dart';

class AmenityTab extends StatefulWidget {
  final User userlogged;
  const AmenityTab(this.userlogged);

  @override
  State<AmenityTab> createState() => _AmenityTabState();
}

class _AmenityTabState extends State<AmenityTab> {
  late Future<List<dynamic>> _dataIndvFuture;

  @override
  void initState() {
    super.initState();

    setState(() {
      _dataIndvFuture = getAmmenityUser(widget.userlogged.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _dataIndvFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("An error occurred."),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning,
                  size: 50, // Adjust the size of the icon as needed
                  color: Colors.red, // Adjust the color of the icon as needed
                ),
                const SizedBox(
                    height:
                        10), // Add some spacing between the icon and the text
                Text(
                  "No Amenity Found",
                  style: Theme.of(context).textTheme.bodyLarge!,
                ),
              ],
            ),
          );
        } else {
          List<dynamic> dataIndv = snapshot.data ?? [];
          dataIndv = dataIndv.reversed.toList();
          return ListView.builder(
            itemCount: dataIndv.length,
            itemBuilder: (context, index) {
              final item = dataIndv[index];

              return ListTile(
                leading: CircleAvatar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    radius: 15.0,
                    child: ((item.amenityPicture) == "")
                        ? const Icon(Icons.access_alarm,
                            size: 30, color: Colors.black)
                        : ClipOval(
                            child: Image.network(
                            item.amenityPicture,
                            width: 30.0,
                            height: 30.0,
                            fit: BoxFit.cover,
                          ))),
                title: Text(item.amenityName),
              );
            },
          );
        }
      },
    );
  }
}
