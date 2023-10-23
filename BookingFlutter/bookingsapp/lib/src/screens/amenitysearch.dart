import 'package:bookingsapp/src/assets/colors.dart';
import 'package:bookingsapp/src/assets/fonts.dart';
import 'package:bookingsapp/src/database/database.dart';
import 'package:bookingsapp/src/models/ammenity.dart';

import 'package:bookingsapp/src/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AmenityAlertBox extends ConsumerStatefulWidget {
  AmenityAlertBox();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AmenityAlertBoxState();
}

class _AmenityAlertBoxState extends ConsumerState<AmenityAlertBox> {
  TextEditingController _text = TextEditingController();
  String like = '';
  Future<List<Amenity>> getAmenity(String like) async {
    var response = await DatabaseQueries.getAmenityRegex(like);
    List<Amenity> amenity = [];

    for (var indv in response.data) {
      Amenity amenityInd = Amenity.defaultAmenity();

      await amenityInd.setData(indv);

      amenity.add(amenityInd);
    }

    return amenity;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: SizedBox(
          height: 400,
          width: 200,
          child: Column(
            children: [
              Container(
                color: ColorCustomScheme.backgroundColor,
                child: TextFormField(
                  onChanged: (text) {
                    setState(() {
                      like = text;
                    });
                  },
                  controller: _text,
                  decoration: InputDecoration(
                    hintText: 'Search Amenity',
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: ColorCustomScheme.appBarColor),
                    ),
                  ),
                  cursorColor: ColorCustomScheme.appBarColor,
                ),
              ),
              FutureBuilder<List<Amenity>>(
                future: getAmenity(like),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(8, 40, 8, 0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(8, 40, 8, 0),
                      child: Center(
                        child: Text(
                          "No Amenity Found",
                          style: FontsCustom.bodyBigText,
                        ),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () async {
                              Navigator.of(context).pop();
                              router.push(
                                  "/amenityBooking/${snapshot.data![index].amenityId}");
                            },
                            leading: CircleAvatar(
                                backgroundColor:
                                    ColorCustomScheme.backgroundColor,
                                radius: 15.0,
                                child: (snapshot.data![index].amenityPicture ==
                                        "")
                                    ? const Icon(Icons.alarm,
                                        size: 30, color: Colors.black)
                                    : ClipOval(
                                        child: Image.network(
                                        snapshot.data![index].amenityPicture,
                                        width: 30.0,
                                        height: 30.0,
                                        fit: BoxFit.cover,
                                      ))),
                            title: Text(snapshot.data![index].amenityName),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
