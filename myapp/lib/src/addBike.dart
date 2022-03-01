import 'package:bike_kollective/helpers/add_bike_image.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/uploadedImage.dart';
import '../helpers/get_user_location.dart';

class BikeFields {
  String model = '';
  String make = '';
  String condition = '';
  String category = '';
  String lock = '';
  int year = 2022;
  String image = '';

  @override
  String toString() {
    return 'Model: $model, Make: $make, Condition: $condition, Category: $category, Lock: $lock, Year: $year, Image: $image';
  }
}

class AddBike extends StatefulWidget {

  

  const AddBike({ Key? key }) : super(key: key);

  @override
  State<AddBike> createState() => _AddBikeState();
}

class _AddBikeState extends State<AddBike> {
  
  final bikeImage = BikeImage();
  final _formKey = GlobalKey<FormState>();
  final bike = BikeFields();
  
  late Widget _icon;

  // Future<void> _dateSelector(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime(2022),
  //     firstDate: DateTime(1900),lastDate: DateTime(2025),
  //     initialDatePickerMode: DatePickerMode.year,
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       bike.year = int.parse(DateFormat('yyyy').format(picked));
  //       Navigator.pop(context);
  //     });
  //   }
  // }

  void initState() {
    super.initState();
    _icon = bikeImage.photo;
  }

  @override
  Widget build(BuildContext context) {

    _icon = bikeImage.photo;

    CollectionReference bikes = FirebaseFirestore.instance.collection('bikes');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add Bike')
      ),
      body: SingleChildScrollView(
        reverse: true,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Add Bike',
                style: 
                  GoogleFonts.pacifico(
                    textStyle: const TextStyle(fontSize: 48)
                  )
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (newVal) {
                          bike.make = newVal ?? '';
                        },
                        decoration: const InputDecoration(
                          labelText: 'Make',
                          border: OutlineInputBorder(),
                        )
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (newVal) {
                          bike.model = newVal ?? '';
                        },
                        decoration: const InputDecoration(
                          labelText: 'Model',
                          border: OutlineInputBorder(),
                        )
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Year: ' + bike.year.toString(),
                              style: const TextStyle(
                                fontSize: 24
                              )
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.indigo
                            ),
                            onPressed: () async {
                              dynamic dialogContext;
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  dialogContext = context;
                                  return AlertDialog(
                                    title: Text('Select Year'),
                                    content: Container(
                                      width: 300,
                                      height: 300,
                                      child: YearPicker(
                                        firstDate: DateTime(DateTime.now().year - 100, 1),
                                        lastDate: DateTime(DateTime.now().year + 100, 1),
                                        initialDate: DateTime.now(),
                                        selectedDate: DateTime.now(),
                                        onChanged: (DateTime dateTime) {
                                          bike.year = int.parse(DateFormat('yyyy').format(dateTime));
                                          setState((){});
                                          Navigator.pop(context);
                                        },
                                      )
                                    )
                                  );
                                }
                              );
                            },
                            child: const Text('Select Year')
                          ),
                          
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (newVal) {
                          bike.condition = newVal ?? '';
                        },
                        decoration: const InputDecoration(
                          labelText: 'Condition',
                          border: OutlineInputBorder(),
                        )
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (newVal) {
                          bike.category = newVal ?? '';
                        },
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        )
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (newVal) {
                          bike.lock = newVal ?? '';
                        },
                        decoration: const InputDecoration(
                          labelText: 'Lock Combination',
                          border: OutlineInputBorder(),
                        )
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            onPressed: () async { 
                              await bikeImage.addPhoto(context);
                              setState(() {
                                _icon = bikeImage.photo;
                              });
                            },
                            icon: const Icon(Icons.camera_alt, size: 40)
                          ),
                          _icon,
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                          onPressed: () => _addBike(bikes),
                          child: const Text('Submit'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          )
                        ]
                      )
                    ]
                  )
                ),
              ),
              
            ],
          ),
        ),
      ));
  }


  Future<void> _addBike( CollectionReference bikes) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bike.image = bikeImage.url;
      Position loc = await getLocation();
      // final location = GeoPoint(latitude: loc.latitude, longitude: loc.longitude);
      bikes.add({
        'available': true,
        'category': bike.category,
        'condition': bike.condition,
        'cur_user': "NULL",
        'image': bike.image,
        'location': GeoPoint(loc.latitude, loc.longitude),
        'lock': bike.lock,
        'make': bike.make,
        'model': bike.model,
        'year': bike.year,
        'stolen': false,
        'rating': 1,
        'tags': [],
        'reviews': [],
        'id': 1
      }).then((value) => print("Bike Added"))
      .catchError((error) => print("Failed to add bike!"));
      // print(bike.image);
      Navigator.pop(context);
    }
  }
}
