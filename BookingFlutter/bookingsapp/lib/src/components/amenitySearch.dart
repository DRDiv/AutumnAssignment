import 'package:bookingsapp/src/functions/get.dart';
import 'package:bookingsapp/src/assets/colors.dart';
import 'package:bookingsapp/src/assets/fonts.dart';
import 'package:bookingsapp/src/models/ammenity.dart';

import 'package:bookingsapp/src/routing/routing.dart';
import 'package:bookingsapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AmenityAlertBox extends ConsumerStatefulWidget {
  const AmenityAlertBox({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AmenityAlertBoxState();
}

class _AmenityAlertBoxState extends ConsumerState<AmenityAlertBox> {
  final TextEditingController _text = TextEditingController();
  String _like = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Theme(
          data: AppTheme.lightTheme(),
          child: SizedBox(
            height: 400,
            width: 200,
            child: Column(
              children: [
                Container(
                  color: ColorSchemes.backgroundColor,
                  child: TextFormField(
                    onChanged: (text) {
                      setState(() {
                        _like = text;
                      });
                    },
                    controller: _text,
                    decoration: const InputDecoration(
                      hintText: 'Search Amenity',
                      prefixIcon: Icon(Icons.search),
                    ),
                    cursorColor: ColorSchemes.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                FutureBuilder<List<Amenity>>(
                  future: getAmenity(_like),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 60,
                            ),
                            Icon(
                              Icons.warning,
                              size: 50, // Adjust the size of the icon as needed
                              color: Colors
                                  .red, // Adjust the color of the icon as needed
                            ),
                            SizedBox(
                                height:
                                    10), // Add some spacing between the icon and the text
                            Text(
                              "No Amenity Found",
                              style: FontsCustom.bodyBigText,
                            ),
                          ],
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
      ),
    );
  }
}

class AmenityTile extends StatelessWidget {
  final Amenity amenity;
  final VoidCallback onTap;

  const AmenityTile({
    super.key,
    required this.amenity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: ColorSchemes.backgroundColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        style: const TextStyle(
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
