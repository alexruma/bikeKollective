import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

Future<String> uploadPic() async {

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  XFile? image;
  final ImagePicker _picker = ImagePicker();
  image = await _picker.pickImage(source: ImageSource.camera);
  
  String photoID = Uuid().v4();
  
  firebase_storage.Reference reference = storage.ref().child('/bikes/$photoID');

  firebase_storage.UploadTask uploadTask = reference.putFile(File(image!.path));

  firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;

  return await taskSnapshot.ref.getDownloadURL();
}

