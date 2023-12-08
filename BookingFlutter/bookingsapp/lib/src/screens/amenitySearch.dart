import 'package:bookingsapp/functions/get.dart';
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
  String _like = '';

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
                color: ColorSchemes.backgroundColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextFormField(
                  onChanged: (text) {
                    setState(() {
                      _like = text;
                    });
                  },
                  controller: _text,
                  decoration: InputDecoration(
                    hintText: 'Search Amenity',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorSchemes.primaryColor),
                    ),
                  ),
                  cursorColor: ColorSchemes.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              FutureBuilder<List<Amenity>>(
                future: getAmenity(_like),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Text(
                          "No Amenity Found",
                          style: FontsCustom.bodyBigText.copyWith(
                            color: Colors.red, // Customize color
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return AmenityTile(
                            amenity: snapshot.data![index],
                            onTap: () async {
                              Navigator.of(context).pop();
                              router.push(
                                  "/amenityBooking/${snapshot.data![index].amenityId}");
                            },
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

class AmenityTile extends StatelessWidget {
  final Amenity amenity;
  final VoidCallback onTap;

  const AmenityTile({
    required this.amenity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: ColorSchemes.backgroundColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: ColorSchemes.tertiaryColor),
      ),
      leading: ClipOval(
        child: Container(
          width: 50,
          height: 50,
          color: ColorSchemes.backgroundColor,
          child: (amenity.amenityPicture == "")
              ? const Icon(Icons.alarm, size: 30, color: Colors.black)
              : Image.network(
                  amenity.amenityPicture,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
        ),
      ),
      title: Text(
        amenity.amenityName,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward,
        color: ColorSchemes.primaryColor,
      ),
    );
  }
}
