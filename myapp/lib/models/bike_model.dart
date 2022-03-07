import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

// Video with example
//https://www.youtube.com/watch?v=sXBJZD0fBa4
class BikeModel extends ChangeNotifier {
  List<Bikes> _bikes = [];

  final _db = FirebaseDatabase.instance.ref('bikes');

  List<Bikes> get bikes => _bikes;

  late StreamSubscription<DatabaseEvent> _bikeStream;
  BikeModel() {
    _listenToBikes();
  }

  void _listenToBikes() {
    _bikeStream = _db.onValue.listen((event) {
      final allBikes = Map<String, dynamic>.from(event.snapshot.value as Map);
      _bikes = allBikes.values
          .map((orderAsJSON) =>
              Bikes.fromFS(Map<String, dynamic>.from(orderAsJSON)))
          .toList();
    });
    notifyListeners();
  }

  @override
  void dispose() {
    _bikeStream.cancel();
    super.dispose();
  }
}

class Bikes {
  final bool available;
  final String category;
  final String condition;
  final String cur_user;
  final int id;
  final GeoPoint location;
  final String lock;
  final String model;
  final int rating;
  final bool stolen;
  final int year;
  int numberOfReviews;

  Bikes(
      {required this.available,
      required this.category,
      required this.condition,
      required this.cur_user,
      required this.id,
      required this.location,
      required this.lock,
      required this.model,
      required this.rating,
      required this.stolen,
      required this.year,
      required this.numberOfReviews});

  factory Bikes.fromFS(Map<String, dynamic> data) {
    return Bikes(
        available: data['available'],
        category: data['category'],
        condition: data['condition'],
        cur_user: data['cur_user'],
        id: data['id'],
        location: data['location'],
        lock: data['lock'],
        model: data['model'],
        rating: data['rating'],
        stolen: data['stolen'],
        year: data['year'],
        numberOfReviews: data['numberOfReviews']);
  }

  //Need to fill in
  Map<String, Object?> toJson() => {
        'available': available,
      };
}
