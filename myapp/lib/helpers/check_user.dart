import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import '/../models/user_model.dart';

class CheckForUser {
  // Reference to users collection
  static final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Function that checks if firebase_auth uid corresponds to document in db.
  // Returns true if document exists.
  static Future<bool> checkDbForUid(String? uid) async {
    try {
      var userDoc = await usersCollection.doc(uid).get();
      return userDoc.exists;
    } catch (e) {
      throw e;
    }
  }
}
