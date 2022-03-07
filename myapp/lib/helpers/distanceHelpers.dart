import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart' as lt;

String distanceConv(meters) {
  if (meters < 1000) {
    double distance = meters * 3.281;
    return "${distance.toStringAsFixed(2)} ft";
  } else {
    double distance = meters / 1609;
    return "${distance.toStringAsFixed(2)} miles";
  }
}

Widget bikeFromUser(bikeid,bikeDistance ) {
  // Gets bike id key and returns distance from user
  return Row(
    children: [
      const Text(
        "Distance: ",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(distanceConv(bikeDistance[bikeid])),
    ],
  );
}

bikeWithinDistance(bike)async{
  LocationData location = await Location().getLocation();
  var curr_distance = lt.Distance().as(lt.LengthUnit.Meter,
      lt.LatLng(location.latitude??50.0, location.longitude??50.0),
      lt.LatLng(bike['location'].latitude,bike['location'].longitude));
  if (curr_distance > 10){
    return false;
  }
  return true;
}