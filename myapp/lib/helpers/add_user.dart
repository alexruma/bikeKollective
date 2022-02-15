import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import '/../models/user_model.dart';

class AddUser extends ChangeNotifier {
  final UserModel userModel;

  AddUser({required this.userModel}) {
    updateUserData();
  }
  final _db = FirebaseDatabase.instance.ref('users');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData() async {
    // await userCollection.add({
    //   'name': userModel.name,
    //   'email': userModel.email,
    //   "id": userModel.userID
    // });
    await userCollection.doc(userModel.userID).set({
      'firstName': userModel.firstName,
      'lastName': userModel.lastName,
      'email': userModel.email,
      "id": userModel.userID
    });
  }
}