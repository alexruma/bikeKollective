

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

emailAlert(context){
  return showDialog(context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text('Email Verification'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
                Text("Your email needs to be verified to continue to use the app.\n"
                    "Please check the email you used to register to continue to use the app.")
              ],
            ),),
          actions: <Widget>[
            TextButton(child: const Text("Close"),
              onPressed: (){
                // SignedOutAction((context) {
                //   Navigator.of(context).pushReplacementNamed('/sign-in');});
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil('/sign-in', (route) => false);
              },)
          ],
        );
      });
}