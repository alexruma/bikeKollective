import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class Gmaps extends StatefulWidget {
  const Gmaps({Key? key}) : super(key: key);

  @override
  _GmapsState createState() => _GmapsState();
}

class _GmapsState extends State<Gmaps> {



  late GoogleMapController mapController;

  // Starting position of the map
  final LatLng _center = const LatLng(45.521563, -122.677433);

  // Function to ask permission for location
  Future<void> requestPermission() async { await Permission.location.request();}

  // Startup tasks when map is created
  void _onMapCreated(GoogleMapController controller){
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
      false,
        appBar: AppBar(title: const Text("Bike Kollective"),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 14,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              initialCameraPosition:
                CameraPosition(target: _center, zoom: 16),
            ),
          )
        ],
      ),
    );
  }


}
