import 'dart:ffi';

import 'package:bike_kollective/models/bike_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart' as lt;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_image/firebase_image.dart';
import 'navbar.dart';

class BikeGrid extends StatefulWidget {
  const BikeGrid({Key? key}) : super(key: key);

  @override
  _BikeGridState createState() => new _BikeGridState();
  }

class _BikeGridState extends State<BikeGrid> {
  final Stream<QuerySnapshot> bikes = FirebaseFirestore.instance.collection('bikes').snapshots();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   title: Text("Bike Kollective"),
        // ), // AppBar
        body: BuildGridView(),
      ); // Scaffold

  Widget BuildGridView() => GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: numbers.length,
      itemBuilder: (context, index) {
        final item = numbers[index];

        return BuildNumber(item);
      }); // GridView.builder

  Widget BuildNumber(String number) => Container(
        padding: EdgeInsets.all(16),
        color: Colors.blue,
        child: GridTile(
          header: Text(
            'Header $number',
            textAlign: TextAlign.center,
          ), // Text
          child: Center(
            child: Text(
              number,
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ); // Container
}
