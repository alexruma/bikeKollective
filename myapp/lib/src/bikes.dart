import 'dart:ffi';
import 'dart:async';
import 'package:bike_kollective/models/bikeTimeAlert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart' as lt;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../helpers/RatingStar.dart';
import '../models/cardImage.dart';
import 'package:bike_kollective/src_exports.dart';

class BikeList extends StatefulWidget {
  const BikeList({Key? key}) : super(key: key);

  @override
  _BikeListState createState() => new _BikeListState();
}

class _BikeListState extends State<BikeList> {
  // ---------------------------------------------------------------------
  // This section is from Gmaps - location finding functions
  // ---------------------------------------------------------------------
  //location
  final Location _location = Location();
  late LocationData _currPosition;

  late StreamSubscription listen;
  //Dictionary of distance from user True or False if close enough
  Map<String, bool> closePoint = {};

  // Dictionary of distance from user to bike
  Map<String, dynamic> bikeDistance = {};
  // Dictionary of bike locations
  Map<String, GeoPoint> bikeLoc = {};

  late GoogleMapController mapController;
  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  late Stream user;

  Map<String, dynamic> bikeinfo = {};

  final Stream<QuerySnapshot> bikes = FirebaseFirestore.instance
      .collection('bikes')
      .where('stolen', isEqualTo: false)
      .snapshots();
  final Stream<DocumentSnapshot> user1 = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .snapshots();
  final CollectionReference currBike =
      FirebaseFirestore.instance.collection('bikes');

  alertTime alert = alertTime();

  // Starting position of the map
  // Location is Oregon state university
  final LatLng _center = const LatLng(44.56457554667605, -123.27994855698064);

  // Function to ask permission for location
  Future<void> requestPermission() async {
    await Permission.location.request();

    setState(() {
      currLocation();
    });
  }

  // Startup tasks when map is created
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // createMarkers();
  }

  //Init State
  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  // Dispose to stop listeners when leaving widget
  @override
  void dispose() async {
    mapController.dispose();
    listen.cancel();
    super.dispose();
  }

  currLocation() async {
    LocationData _currPosition = await _location.getLocation();
    const lt.Distance distance = lt.Distance();
    // _location.changeSettings(interval: 4000);
    listen = _location.onLocationChanged.listen((event) {
      if (mounted) {
        setState(() {
          bikeLoc.forEach((key, value) {
            var space1 = distance.as(
                lt.LengthUnit.Meter,
                lt.LatLng(event.latitude ?? 00.0, event.longitude ?? 00.00),
                lt.LatLng(value.latitude, value.longitude));
            bikeDistance[key] = space1;
            closePoint[key] = space1 < 10;
          });
        });
      }
    });
    return _currPosition;
  }

  double distanceConvDouble(meters) {
    if (meters < 1000) {
      double distance = meters * 3.281;
      return distance;
    } else {
      double distance = meters / 1609;
      return distance;
    }
  }

  String distanceConvStr(meters) {
    if (meters < 1000) {
      double distance = meters * 3.281;
      return "${distance.toStringAsFixed(2)} ft";
    } else {
      double distance = meters / 1609;
      return "${distance.toStringAsFixed(2)} miles";
    }
  }

  Widget bikeFromUser(data) {
    // Gets bike id key and returns distance from user
    return Row(
      children: [
        const Text(
          "Distance: ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        //Text(distanceConvStr(bikeDistance[data])),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // End of Gmaps code
  // ---------------------------------------------------------------------

  bool isIn(list, term) {
    for (var item in list) {
      if (item.toLowerCase().contains(term.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  String searchTerm = "";

// Builds the card for the bike shown on the
  Widget buildBikeCard(document) {
    return GestureDetector(
      child: Container(
          height: 150,
          child: Card(
            color: Colors.lightBlue[50],
            child: Row(
              children: [
                Expanded(
                  flex: 33,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      shape: BoxShape.rectangle,
                    ),
                    child: cardImage(
                      document['image'],
                    ),
                  ),
                ),
                Expanded(
                    flex: 66,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 20,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Type: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text('${document['category']}')
                              ]),
                        ),
                        if (bikeDistance.containsKey(document.id))
                          Expanded(
                              flex: 20,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Distance: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    bikeFromUser(bikeDistance[document.id]),
                                  ])),
                        Expanded(
                          flex: 20,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Year: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text('${document['year']}')
                              ]),
                        ),
                        Expanded(
                          flex: 20,
                          child: Row(children: [
                            Text('                 '),
                            RatingStar(rating: document['rating'])
                          ]),
                        ),
                        Expanded(
                          flex: 20,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Tags: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                if (document['tags'].isEmpty)
                                  const Text('None'),
                                if (document['tags'].isNotEmpty)
                                  Expanded(
                                    child: Text('${document['tags']}',
                                        overflow: TextOverflow.fade),
                                  ),
                              ]),
                        ),
                      ],
                    )),
              ],
            ),
          )),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SingleBike(
                bikeId: document.id,
              ))),
    );
  }

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
                  bikeLoc[document.id] = document['location'];

                  if (searchTerm.isNotEmpty &&
                      isIn(document['tags'], searchTerm) &&
                      document['available'] != false) {
                    return buildBikeCard(document);
                  } else if (searchTerm.isEmpty &&
                      document['available'] != false) {
                    return buildBikeCard(document);
                  } else {
                    return SizedBox.shrink();
                  }
                }); // ListView
          }), // Stream builder
    ); // Scaffold
  }
}
