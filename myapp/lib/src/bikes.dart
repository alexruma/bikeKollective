import 'dart:async';
import 'package:bike_kollective/helpers/distanceHelpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../helpers/RatingStar.dart';
import '../models/cardImage.dart';
import 'package:bike_kollective/src_exports.dart';

class BikeList extends StatefulWidget {
  const BikeList({Key? key}) : super(key: key);

  @override
  _BikeListState createState() => _BikeListState();
}

class _BikeListState extends State<BikeList> {
  // ---------------------------------------------------------------------
  // This section is from Gmaps - location finding functions
  // ---------------------------------------------------------------------

  // Dictionary of distance from user to bike
  Map<String, dynamic> bikeDistance = {};

  Map<String, dynamic> bikeinfo = {};

  // Function to ask permission for location
  Future<void> requestPermission() async {
    await Permission.location.request();
    setState(() {
    });
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
    super.dispose();
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
        Text(distanceConvStr(bikeDistance[data])),
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
                                    bikeFromUser(document.id),
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
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
          preferredSize: const Size.fromHeight(0.0),
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
                      const Icon(Icons.search, color: Colors.grey),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration.collapsed(
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
              return const Center(
                child: CircularProgressIndicator(),
              ); // Center
            }
            return FutureBuilder(
                future: bikeListSort(snapshot.data?.docs),
                builder: (BuildContext context, snapshot){
                  if(!snapshot.hasData){
                    return const Center(
                        child: CircularProgressIndicator());
                  }
                  List Bikes = snapshot.data as List;

                  return FutureBuilder(
                      future: bikeDistanceFromUser(Bikes),
                      builder: (BuildContext context, bikedist){
                        if(!bikedist.hasData){
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        bikeDistance = bikedist.data as Map<String, dynamic>;
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: Bikes.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot document =
                              Bikes[index] as DocumentSnapshot;
                              // bikeLoc[document.id] = document['location'];

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
                            });
                      });


                });

             // ListView
          }), // Stream builder
    ); // Scaffold
  }
}
