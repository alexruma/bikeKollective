import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class Gmaps extends StatefulWidget {
  const Gmaps({Key? key}) : super(key: key);

  @override
  _GmapsState createState() => _GmapsState();
}

class _GmapsState extends State<Gmaps> {

  late GoogleMapController mapController;
  List<Marker> _markers = <Marker>[];
  //Stream collectionStream = FirebaseFirestore.instance.collection('bikes').snapshots();
  var markers;
  final Stream<QuerySnapshot> bikes = FirebaseFirestore.instance.collection('bikes').snapshots();

  // Starting position of the map
  // Location is Oregon state university
  final LatLng _center = const LatLng(44.56457554667605, -123.27994855698064);

  // Function to ask permission for location
  Future<void> requestPermission() async { await Permission.location.request();}

  // Startup tasks when map is created
  void _onMapCreated(GoogleMapController controller){
    createMarkers();
    mapController = controller;
  }

  //Init State
  @override
  void initState(){
    super.initState();
    requestPermission();
  }

  // Dispose to stop listeners when leaving widget
  @override
  void dispose() async{
    super.dispose();
  }


  createMarkers() async {
    //Markers for Bike available Locations
    // Calls firestore and gets bike info
    markers = [];
    FirebaseFirestore.instance.collection('bikes').get()
        .then((docs) {
      docs.docs.forEach((element) {
        //print(element['make']);
        initMarker(element);
      });
    });



  }

  initMarker(bike){
    // Set state neede to update markers on Gmap
    setState(() {
    _markers.add(Marker(
        markerId: MarkerId(bike['make']),
        position: LatLng(bike['location'].latitude,
            bike['location'].longitude),
        infoWindow: InfoWindow(title: bike['model'])
    ));
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
      false,
        appBar: AppBar(title: const Text("Bike Kollective"),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 14,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              initialCameraPosition:
                CameraPosition(target: _center, zoom: 16),
              markers: Set<Marker>.of(_markers),
            ),
          ),
          Expanded(flex: 5,
          child:
          StreamBuilder<QuerySnapshot>(stream: bikes,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot){
            if (snapshot.hasError){
              return Text('Something went wrong.');}
            if (snapshot.connectionState == ConnectionState.waiting){
              return Text('Loading');
            }
            final data = snapshot.requireData;
            var items = snapshot.data?.docs ?? [];

            //Stream which updates markers on change
            // Will Use later
            // items.forEach((element) {
            //   print(element['location'].latitude);
            //   _markers.add(Marker(
            //     markerId: MarkerId(element['make']),
            //     position: LatLng(element['location'].latitude,
            //               element['location'].longitude),
            //     infoWindow: InfoWindow(title: element['model'])
            //   ));

            // });


            return ListView.builder(
                itemCount: data.size,
                itemBuilder: (context, index){

                  return Text('This bike is ${data.docs[index]['make']}');
                });

          }))
        ],
      ),
    );
  }


}
