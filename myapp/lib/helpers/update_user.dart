import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import '/../models/user_model.dart';

class NewUser extends ChangeNotifier {
  final UserModel userModel;

  NewUser({required this.userModel}) {
    updateUserData();
  }
  final _db = FirebaseDatabase.instance.ref('users');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData() async {
    return await userCollection.doc(userModel.userID).update({
      'firstName': userModel.firstName,
      'lastName': userModel.lastName,
      'email': userModel.email,
      "id": userModel.userID
    });
  }
}
