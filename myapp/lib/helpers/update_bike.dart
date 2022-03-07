import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import '/../models/user_model.dart';

class BikeUpdate {
  final String? bikeDocId;

  BikeUpdate({required this.bikeDocId}) {
    //updateBikeData();
  }
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('bikes');

  Future updateBikeRating(newRating, oldRating, numberOfRatings) async {
    numberOfRatings += 1;
    var newAvgRating = (newRating + oldRating) / numberOfRatings;

    return await userCollection
        .doc(bikeDocId)
        .update({"rating": newAvgRating, "numberOfRatings": numberOfRatings});
  }

  Future updateBikeTags(newTag, oldTags) async {
    oldTags.add(newTag);
    return await userCollection.doc(bikeDocId).update({"tags": oldTags});
  }
}
