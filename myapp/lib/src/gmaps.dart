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



class Gmaps extends StatefulWidget {
  const Gmaps({Key? key}) : super(key: key);

  @override
  _GmapsState createState() => _GmapsState();
}

class _GmapsState extends State<Gmaps> {

  //location
  final Location  _location = Location();
  late var listen = _location.onLocationChanged.listen((event) { });

  //Dictionary of distance from user
  Map<String, bool> closePoint = {};

  // Dictionary of bike locations
  Map<String, GeoPoint> bikeLoc = {};

  late GoogleMapController mapController;
  final List<Marker> _markers = <Marker>[];


  final Stream<QuerySnapshot> bikes = FirebaseFirestore.instance.collection('bikes')
      .withConverter<Bikes>(fromFirestore: (snapshot, _) => Bikes.fromFS(snapshot.data()!),
      toFirestore: (bikes, _)=> bikes.toJson()).snapshots();

  // Starting position of the map
  // Location is Oregon state university
  final LatLng _center = const LatLng(44.56457554667605, -123.27994855698064);

  // Function to ask permission for location
  Future<void> requestPermission() async { await Permission.location.request();}
  // Startup tasks when map is created
  void _onMapCreated(GoogleMapController controller){

    mapController = controller;
    createMarkers();
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
    mapController.dispose();
    listen.cancel();
    super.dispose();
  }

  currLocation() async {
    var _currPosition = await _location.getLocation();
    final lt.Distance distance = lt.Distance();
    _location.onLocationChanged.listen((event) {
      setState(() {
        //print(event);
        bikeLoc.forEach((key, value) {
          var space1 = distance.as(lt.LengthUnit.Meter,
            lt.LatLng(event.latitude??00.0,event.longitude??00.00),
            lt.LatLng(value.latitude,value.longitude));
            closePoint[key] = space1 < 10;
        }
            );
      });
    });
    return _currPosition;
  }

  // double closeDistance(location, curr) {
  //
  //
  //   final lt.Distance distance = lt.Distance();
  //   var space1 = distance.as(lt.LengthUnit.Meter,
  //       lt.LatLng(curr.latitude??0.00,curr.longitude??00.00),
  //       lt.LatLng(location.latitude, location.longitude));
  //
  //   print(space1);
  //   print("${curr.latitude}, ${curr.latitude}");
  //   print("${location.latitude}, ${location.longitude}");
  //   return space1;
  // }



  createMarkers() async {
    //Markers for Bike available Locations
    // Calls firestore and gets bike info

    FirebaseFirestore.instance.collection('bikes').get()
        .then((docs) {
      docs.docs.forEach((element) {
        //print(element['make']);
        initMarker(element);
      });
    });

    // //TEST
    // bikes?.forEach((bike) { initMarker(bike);});
  setState(() { _markers;

  });
  }

  initMarker(bike){
    // Set state need to update markers on Gmap

      var rating = bike['rating'];
      var hue = BitmapDescriptor.hueAzure;

      // Changes the color of the icon based on the rating
      switch(rating){
        case 5:{hue = BitmapDescriptor.hueGreen;}
        break;
        case 4:{hue = BitmapDescriptor.hueAzure;}
        break;
        case 3:{hue = BitmapDescriptor.hueOrange;}
        break;
        case 2:{hue = BitmapDescriptor.hueYellow;}
        break;
        case 1: {hue = BitmapDescriptor.hueRed;}
        break;
        default:{}
        break;
      }

    _markers.add(Marker(
        markerId: MarkerId(bike['make']),
        position: LatLng(bike['location'].latitude,
            bike['location'].longitude),
        infoWindow: InfoWindow(title: bike['model']),
        icon: BitmapDescriptor.defaultMarkerWithHue(hue)
    ));

  }



  @override
  Widget build(BuildContext context) {
  currLocation();
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
              return const Text('Something went wrong.');}
            if (snapshot.connectionState == ConnectionState.waiting){
              return const Text('Loading');
            }
            final data = snapshot.requireData;
            var items = snapshot.data?.docs;
            items?.forEach((bike) {initMarker(bike);});
            _markers;


            return ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: data.size,
                itemBuilder: (context, index){
                  bikeLoc[data.docs[index].id] = data.docs[index]['location'];
                  var dist = 5;
                  return
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: Colors.black12),
                          color: Colors.grey,),
                        width: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [const Expanded(
                              flex: 4,
                              child: Image(image: AssetImage('assets/images/bike-icon.png'),
                              height: 100
                              ,)),
                            Expanded(child: RatingStar(rating: data.docs[index]['rating']),
                            flex: 1,),
                            Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Expanded(flex: 1,
                                  child: Row(
                                    children: [
                                      ElevatedButton(style: const ButtonStyle(),
                                      onPressed: () {  },
                                      child: const Text('View Bike',
                                        style: TextStyle(color: Colors.black87),),),

                                      // Will be used to select bike if within distance
                                      if(closePoint[data.docs[index].id]??false)
                                        ElevatedButton(onPressed: (){}, child:
                                        const Text('Select Bike',
                                          style: TextStyle(color: Colors.black54),))
                                    ],
                                  ) ),
                            ),
                          ],
                        )
                      ),
                    );
                });
          }))
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
      child: Row( children:
        List.generate(5,(index) {
        return(Icon(index >= rating ? Icons.star_border  :Icons.star,
            color: index >= rating ? Colors.yellow : Colors.yellow));
      })
        ),
    );
  }
}

