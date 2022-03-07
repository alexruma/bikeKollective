import 'dart:ffi';

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
import 'package:bike_kollective/src_exports.dart';

class BikeList extends StatefulWidget {
  const BikeList({Key? key}) : super(key: key);

  @override
  _BikeListState createState() => new _BikeListState();
}

class _BikeListState extends State<BikeList> {
// List build
  TextEditingController _searchInputController = TextEditingController();

  // Taken from Gmaps
  Widget cardImage(image) {
    if (image == "") {
      return const Image(
        image: AssetImage('assets/images/bike-icon.png'),
        width: 200,
        height: 200,
      );
    } else {
      return Image(
        image: FirebaseImage(image),
        width: 200,
        height: 200,
      );
    }
  }

  String searchTerm = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0.0),
          child: Container(
              //  padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300],
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Material(
                  color: Colors.grey[300],
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.search, color: Colors.grey),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration.collapsed(
                            hintText: 'Search',
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchTerm = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('bikes').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              ); // Center
            }

            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document =
                      snapshot.data?.docs[index] as DocumentSnapshot;

                  if (searchTerm.isNotEmpty &&
                          document['category'].contains(searchTerm) ||
                      searchTerm.isNotEmpty &&
                          document['year'].toString().contains(searchTerm) ||
                      searchTerm.isNotEmpty &&
                          document['rating'].toString().contains(searchTerm)) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      tileColor: Colors.lightBlueAccent,
                      leading: cardImage(document['image']),
                      title: Text('Type: ${document['category']}',
                          textAlign: TextAlign.left),
                      subtitle: Text('Year: ${document['year']}'),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SingleBike(
                                bikeDoc: document,
                                bikeId: document.id,
                              ))),
                    ); // ListTile
                  } else if (searchTerm.isEmpty) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      tileColor: Colors.lightBlueAccent,
                      leading: cardImage(document['image']),
                      title: Text('Type: ${document['category']}',
                          textAlign: TextAlign.left),
                      subtitle: Text('Year: ${document['year']}'),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SingleBike(
                                bikeDoc: document,
                                bikeId: document.id,
                              ))),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }); // ListView
          }), // Stream builder
    ); // Scaffold
  }
}
