

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

bannedAlert(context){
  return showDialog(context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text('Banned'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
                Text("You have been banned from this app for failing to return"
                    " a bike within 12 hours. Contact an administrator to regain access")
              ],
            ),),
          actions: <Widget>[
            TextButton(child: const Text("Return to Login Screen"),
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