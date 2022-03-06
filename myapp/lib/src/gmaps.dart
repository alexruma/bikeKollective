import 'dart:async';

import 'package:bike_kollective/models/bikeTimeAlert.dart';
import 'package:bike_kollective/models/bike_model.dart';
import 'package:bike_kollective/models/bannedAlert.dart';

import 'package:bike_kollective/src/checkoutBike.dart';
import 'package:bike_kollective/src/returnBike.dart';
import 'package:bike_kollective/src/stolenBike.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart' as lt;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_image/firebase_image.dart';

class Gmaps extends StatefulWidget {
  const Gmaps({Key? key}) : super(key: key);

  @override
  _GmapsState createState() => _GmapsState();
}

class _GmapsState extends State<Gmaps> {
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

  final Stream<QuerySnapshot> bikes =
      FirebaseFirestore.instance.collection('bikes').snapshots();
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

  String distanceConv(meters) {
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
        Text(distanceConv(bikeDistance[data])),
      ],
    );
  }

  // createMarkers() async {
  //   //Markers for Bike available Locations
  //   // Calls firestore and gets bike info
  //   FirebaseFirestore.instance.collection('bikes').get()
  //       .then((docs) {
  //
  //     docs.docs.forEach((element) {
  //       initMarker(element);
  //     });
  //   });
  //
  //   setState(() {
  //     _markers;
  //   });
  // }

  initMarker(bike) {
    // Set state need to update markers on Gmap
    // Set state handled with location update.
    var rating = bike['rating'];
    var hue = BitmapDescriptor.hueAzure;

    // Changes the color of the icon based on the rating
    switch (rating) {
      case 5:
        {
          hue = BitmapDescriptor.hueGreen;
        }
        break;
      case 4:
        {
          hue = BitmapDescriptor.hueAzure;
        }
        break;
      case 3:
        {
          hue = BitmapDescriptor.hueOrange;
        }
        break;
      case 2:
        {
          hue = BitmapDescriptor.hueYellow;
        }
        break;
      case 1:
        {
          hue = BitmapDescriptor.hueRed;
        }
        break;
      default:
        {}
        break;
    }
    var temp = (Marker(
        markerId: MarkerId(bike.id),
        position: LatLng(bike['location'].latitude, bike['location'].longitude),
        infoWindow: InfoWindow(title: bike['model']),
        icon: BitmapDescriptor.defaultMarkerWithHue(hue),
        // Markers are invisible if bike not available
        visible: bike['available'] ? true : false));
    _markers[temp.markerId] = temp;
  }

  moveCamera(location) async {
    double curZoom = await mapController.getZoomLevel();
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(location.latitude, location.longitude), zoom: curZoom)));
  }

  Widget zoomButtons() {
    return Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            height: 80,
            width: 40,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(.45),
                border: Border.all(color: Colors.black.withOpacity(.45))),
            child: Column(
              children: [
                FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.black.withOpacity(.45)))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          mapController.animateCamera(CameraUpdate.zoomIn());
                        },
                        child: const Icon(Icons.add, color: Colors.blueAccent),
                      ),
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        mapController.animateCamera(CameraUpdate.zoomOut());
                      },
                      child: const Icon(Icons.remove, color: Colors.blue),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _GoogleMap(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
      initialCameraPosition: CameraPosition(target: _center, zoom: 16),
      markers: Set<Marker>.of(_markers.values),
    );
  }

  Widget cardImage(image) {
    if (image == "") {
      return const Image(
        image: AssetImage('assets/images/bike-icon.png'),
        width: 200,
        height: 100,
      );
    } else {
      return Image(
        image: FirebaseImage(image),
        width: 200,
        height: 100,
      );
    }
  }

  Widget Bikelist() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
          height: 225,
          child: StreamBuilder<QuerySnapshot>(
              stream: bikes,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong.');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading');
                }
                final data = snapshot.requireData;
                var items = snapshot.data?.docs;
                //Bikes added to dictionary
                //Updated through location update

                items?.forEach((bike) {
                  initMarker(bike);
                });

                //List builder for bike list
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      bikeLoc[data.docs[index].id] =
                          data.docs[index]['location'];
                      if (data.docs[index]['available'] != false) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: GestureDetector(
                              onTap: () {
                                moveCamera(data.docs[index]['location']);
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    border: Border.all(color: Colors.black12),
                                    color: Colors.grey.withOpacity(.95),
                                  ),
                                  width: 275,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            cardImage(data.docs[index]['image'])
                                          ]),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RatingStar(
                                              rating: data.docs[index]
                                                  ['rating']),
                                        ],
                                      ),
                                      if (bikeDistance
                                          .containsKey(data.docs[index].id))
                                        bikeFromUser(data.docs[index].id),
                                      Row(children: [
                                        const Text(
                                          "Type: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("${data.docs[index]['category']}"),
                                        const Text(
                                          " Year: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("${data.docs[index]['year']}"),
                                        const Text(
                                          " Condition: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("${data.docs[index]['condition']}")
                                      ]),
                                      Row(
                                        children: [
                                          const Text(
                                            "Make: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text('${data.docs[index]['make']}'),
                                          const Text(
                                            " Model: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text('${data.docs[index]['model']}')
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Tags: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${data.docs[index]['tags']}",
                                            overflow: TextOverflow.fade,
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Row(
                                          children: [
                                            ElevatedButton(
                                              style: const ButtonStyle(),
                                              onPressed: () {},
                                              child: const Text(
                                                'View Bike',
                                                style: TextStyle(
                                                    color: Colors.black87),
                                              ),
                                            ),

                                            // Will be used to select bike if within distance
                                            if (closePoint[
                                                    data.docs[index].id] ??
                                                false)
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                checkoutBike(
                                                                    bikeId: data
                                                                        .docs[
                                                                            index]
                                                                        .id)));
                                                  },
                                                  child: const Text(
                                                    'Select Bike',
                                                    style: TextStyle(
                                                        color: Colors.black54),
                                                  ))
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    });
              })),
    );
  }

  Widget userInfo() {
    return StreamBuilder<DocumentSnapshot>(
      stream: user1,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong.');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading');
        }

        final userdata = snapshot.requireData;

        if (userdata['banned'] == true) {
          // If the user is banned show a dialog
          // and sign user out.
          // Unban with firestore.
          WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
            bannedAlert(context);
          });
        }
        if (userdata['bikeCheckedOut'] != "") {
          // Clear all markers and show current bike
          _markers.clear();
          return user_bike_check(userdata);
        }
        return Bikelist();
      },
    );
  }

  Widget user_bike_check(userdata) {
    return FutureBuilder<DocumentSnapshot>(
      future: currBike.doc(userdata['bikeCheckedOut']).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Bike does note exist.");
        }
        if (snapshot.data?.data() != null) {
          Map<String, dynamic> bikeinfo =
              snapshot.data?.data() as Map<String, dynamic>;
          if (bikeinfo.isNotEmpty) {
            // Logic for return bike after 8 hours before 12 hours
            if (alert.alertedTime
                    .add(const Duration(minutes: 20))
                    .isBefore(DateTime.now()) &&
                alert.alerted == true) {
              alert.alerted = false;
            }
            if (alert.alerted == false && overtime(bikeinfo['checkoutTime'])) {
              WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                bikeTimeAlert(context);
              });
              alert.alerted = true;
              alert.alertedTime = DateTime.now();
            }

            return Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: 275,
                  width: double.infinity,
                  color: Colors.grey.withOpacity(.95),
                  child: FittedBox(
                      fit: BoxFit.contain,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: const [Text("Current Bike")],
                            ),
                            Row(
                              children: [cardImage(bikeinfo['image'])],
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RatingStar(
                                    rating: bikeinfo['rating'],
                                  )
                                ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Type: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text("${bikeinfo['category']}"),
                                  const Text(
                                    " Year: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text("${bikeinfo['year']}"),
                                  const Text(
                                    " Condition: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text("${bikeinfo['condition']}")
                                ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Make: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('${bikeinfo['make']}'),
                                const Text(
                                  " Model: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('${bikeinfo['model']}')
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Tags: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${bikeinfo['tags']}",
                                  overflow: TextOverflow.fade,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    "Please return bike before ${DateFormat.jm().format(bikeinfo['checkoutTime'].toDate().add(const Duration(hours: 6)))}")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  child: const Text("Return Bike"),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => returnBike(
                                                bikeId: snapshot.data!.id)));
                                  },
                                ),
                                ElevatedButton(
                                  child: const Text("Report Stolen"),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red)),
                                  onPressed: () {
                                    stolenBike(context, bikeinfo,
                                        userdata['bikeCheckedOut']);
                                    // print("HERE");
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      )),
                ));
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Google Map
          _GoogleMap(context),
          //Bike List Widget
          userInfo(),
          zoomButtons(),
        ],
      ),
    );
  }
}

class RatingStar extends StatelessWidget {
  const RatingStar({Key? key, required this.rating}) : super(key: key);

  final int rating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
          children: List.generate(5, (index) {
        return (Icon(index >= rating ? Icons.star_border : Icons.star,
            color: index >= rating ? Colors.yellow : Colors.yellow));
      })),
    );
  }
}
