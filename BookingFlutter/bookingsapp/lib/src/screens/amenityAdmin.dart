import 'dart:io';
import 'package:bookingsapp/src/components/loading.dart';
import 'package:bookingsapp/src/components/slotPicker.dart';
import 'package:bookingsapp/src/database/dbAmenity.dart';
import 'package:bookingsapp/src/functions/format.dart';
import 'package:bookingsapp/src/providers/userLoggedProvider.dart';
import 'package:bookingsapp/src/routing/routing.dart';
import 'package:bookingsapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AmenityAdmin extends ConsumerStatefulWidget {
  const AmenityAdmin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AmenityAdminState();
}

class _AmenityAdminState extends ConsumerState<AmenityAdmin> {
  final List<Map<String, dynamic>> _slotDataList = [];
  final List<Slot> _slots = [];
  File? _amenityPicture;
  String _selectedOption = 'Daily';

  List<String> options = [
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
    'One Time',
  ];
  final TextEditingController _amenityName = TextEditingController();
  final TextEditingController _amenityDescription = TextEditingController();
  double _capacity = 1.0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Theme(
      data: AppTheme.lightTheme(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Create Amenity",
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 2,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    (_amenityPicture == null)
                        ? const Center(
                            child: Icon(
                              Icons.category_sharp,
                              color: Colors.black,
                              size: 100,
                            ),
                          )
                        : Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.file(
                                _amenityPicture!,
                                fit: BoxFit.cover,
                                width: 250,
                              ),
                            ),
                          ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: FloatingActionButton(
                        child: const Icon(Icons.add),
                        onPressed: () async {
                          File? amenityPictureGet = await getImage(ref);
                          setState(() {
                            _amenityPicture = amenityPictureGet;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Center(
                child: SizedBox(
                  width: 0.8 * width,
                  child: TextFormField(
                    controller: _amenityName,
                    decoration:
                        const InputDecoration(hintText: "Enter Amenity Name"),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                  width: 0.8 * width,
                  child: TextFormField(
                    controller: _amenityDescription,
                    maxLines:
                        3, // Set the number of lines you want for description
                    decoration: const InputDecoration(
                        hintText: "Enter Amenity Description"),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text('Capacity: ${_capacity.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyLarge!),
              Slider(
                value: _capacity,
                onChanged: (newValue) {
                  setState(() {
                    _capacity = newValue;
                  });
                },
                min: 1,
                max: 200,
                divisions: 199, // Number of discrete divisions
                label: _capacity.toStringAsFixed(0),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Select Recurrance: ',
                    style: Theme.of(context).textTheme.bodyLarge!,
                  ),
                  DropdownButton<String>(
                    value: _selectedOption,
                    items: options.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedOption = newValue!;
                      });
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SlotsEditor(_slotDataList, _slots),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 0.8 * width,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_amenityName.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Amenity name cannot be empty'),
                          ),
                        );
                        return;
                      }
                      if (_slots.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("No slots selected"),
                          ),
                        );
                      }
                      showLoadingDialog(context);
                      await DatabaseQueriesAmenity.createAmenity(
                          _amenityName.text,
                          ref.read(userLogged).userId,
                          _selectedOption,
                          _slots,
                          _amenityPicture,
                          _capacity,
                          _amenityDescription.text);
                      router.pop();
                      router.pop();
                    },
                    child: const Text('Confirm')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
