import 'package:flutter/cupertino.dart';

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