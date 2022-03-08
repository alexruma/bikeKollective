import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import '/../models/user_model.dart';

class BikeUpdate {
  final String? bikeDocId;

  BikeUpdate({required this.bikeDocId});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('bikes');

  // Call to update  bike rating.
  Future updateBikeRating(newRating, oldRating, numberOfRatings) async {
    numberOfRatings += 1;
    // Calculate new average rating.
    var newAvgRating =
        ((oldRating * (numberOfRatings - 1)) + newRating) / numberOfRatings;

    return await userCollection.doc(bikeDocId).update({
      "rating": newAvgRating.roundToDouble(),
      "numberOfRatings": numberOfRatings
    });
  }

  // Adds a single new tage to the tags field.
  Future updateBikeTags(newTag, oldTags) async {
    oldTags.add(newTag);
    return await userCollection.doc(bikeDocId).update({"tags": oldTags});
  }
}
