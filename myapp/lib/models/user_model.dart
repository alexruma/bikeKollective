import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class UserModel {
  String? userID;
  String? firstName;
  String? lastName;
  String? email;
  final bool banned = false;
  final bool waiver = true;
  String? dob;
  String? phoneNumber;
  var bikesAdded = [];
  String bikeCheckedOut = "";
  // factory UserModel.fromFS(Map<String, dynamic> data) {
  //   return UserModel(
  //     userID: data['userID'],
  //     firstName: data['firstName'],
  //     lastName: data['lastName'],
  //     email: data['email'],
  //     dob: data['dob'],
  //     phoneNumber: data['phoneNumber'],
  //   );
  // }

  UserModel(Map<String, String?> data) {
    userID = data['userID'];
    firstName = data['firstName'];
    lastName = data['lastName'];
    email = data['email'];
    dob = data['dob'];
    phoneNumber = data['phoneNumber'];
  }

  //UserModel(this.userID, this.email);
}
