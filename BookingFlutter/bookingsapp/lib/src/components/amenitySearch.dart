import 'package:bookingsapp/src/database/dbAmenity.dart';

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
                TextFormField(
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
                ),
                const SizedBox(height: 8),
                FutureBuilder<List<Amenity>>(
                  future: getAmenity(_like),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Column(
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 60,
                            ),
                            const Icon(
                              Icons.warning,
                              size: 50,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "No Amenity Found",
                              style: Theme.of(context).textTheme.bodyLarge!,
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
                                router.pop();
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
      leading: ClipOval(
        child: Container(
          width: 50,
          height: 50,
          color: Theme.of(context).scaffoldBackgroundColor,
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
      ),
      trailing: const Icon(
        Icons.arrow_forward,
      ),
    );
  }
}
