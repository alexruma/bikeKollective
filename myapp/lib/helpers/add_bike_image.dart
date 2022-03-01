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

Future<String> uploadPic(BuildContext context) async {

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  XFile? image;
  final ImagePicker _picker = ImagePicker();
  image = await _picker.pickImage(source: ImageSource.camera);
  if (image == null) {
    return '';
  }
  dynamic dialogContext;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      dialogContext = context;
      return AlertDialog(
        title: Text('Uploading Photo...'),
        content: Container(
          width: 100,
          height: 100,
          child: Center(child: CircularProgressIndicator())
        )
      );
    }
  );

  String photoID = const Uuid().v4();
  
  firebase_storage.Reference reference = storage.ref().child('/bikes/$photoID.jpg');

  if (image == null) {
    return '';
  }
  firebase_storage.UploadTask uploadTask = reference.putFile(File(image.path));

  firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;

  Navigator.pop(dialogContext);
  return "gs://bikekollective-467.appspot.com/" + taskSnapshot.metadata!.fullPath;
}

