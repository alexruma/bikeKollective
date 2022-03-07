import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

bikeTimeAlert(context){
  return showDialog(context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text('Current Bike'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
                Text("You have checked out this bike for more than 8 hours. "
                    "Consider turning it in and giving another user a chance with"
                    " the bike.")
              ],
            ),),
          actions: <Widget>[
            TextButton(child: const Text("Exit"),
              onPressed: (){
              Navigator.of(context).pop();

              },)
          ],
        );
      });
}

overtime(bikeTime){
  DateTime bikeCheckoutTime = bikeTime.toDate();
  bikeCheckoutTime= bikeCheckoutTime.add(const Duration(hours: 8));
  if(bikeCheckoutTime.isBefore(DateTime.now())){
    return true;
  }
  return false;
}

class alertTime{
  bool alerted = false;
  DateTime alertedTime = DateTime.now();
}

//Current Settings
// Cloud FUnction - Banned Function run every 10 min. 24 hr limit
// App 24 hr limit. Alert every 20 minutes after 8 hrs.