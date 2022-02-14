import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class UserModel {
  final String userID;
  final String firstName;
  final String lastName;
  final String email;
  final bool banned = false;
  final bool waiver = true;
  String? dob;

  UserModel(this.userID, this.firstName, this.lastName, this.email);
}
