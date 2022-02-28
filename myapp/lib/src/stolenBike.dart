// import 'package:bike_kollective/models/cardImage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class stolenBike extends StatefulWidget {
//
//   stolenBike({Key? key,required this.bikeId}) : super(key: key);
//   String bikeId;
//   @override
//   stolenBikeState createState() => stolenBikeState();
// }
//
// class stolenBikeState extends State<stolenBike> {
//
//   CollectionReference bike = FirebaseFirestore.instance.collection('bikes');
//   Map<String, dynamic> bikeinfo = {};
//
//   Future<Map<String, dynamic>> getBikeInfo() async {
//     return await bike.doc(widget.bikeId).get().then((DocumentSnapshot value) {
//       bikeinfo = value.data() as Map<String, dynamic>;
//
//       return bikeinfo;
//     }
//     );
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: getBikeInfo(),
//         builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//           if (!snapshot.hasData) {
//             return AlertDialog();
//
//           } else {
//             return AlertDialog(title: const Text('Report Stolen Bike'),
//                 content: SingleChildScrollView(
//                   child: ListBody(
//                     children: [
//                       cardImage(snapshot.data['image']),
//                     ],
//
//                   ),
//
//                 ),
//             actions: <Widget>[TextButton(
//                     child: Text("Report Stolen"),
//             onPressed: (){
//               Navigator.popUntil(context, ModalRoute.withName('/home'));
//             },)],);
//
//             //   Scaffold(
//             //   appBar: AppBar(title: const Text('Report Stolen Bike'),),
//             //   body: SingleChildScrollView(
//             //     child: Center(
//             //       child: Column(
//             //         mainAxisAlignment: MainAxisAlignment.center,
//             //         children: [
//             //           const Text("Stolen Bike"),
//             //           cardImage(snapshot.data['image']),
//             //           ElevatedButton(
//             //             child: Text("TEST"),
//             //             onPressed: (){
//             //               Navigator.popUntil(context, ModalRoute.withName('/home'));
//             //             }, )
//             //
//             //
//             //         ],
//             //       ),
//             //     ),
//             //   ),
//             // );
//           }
//         });
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/cardImage.dart';

stolenBike(context, bike, bikeid){
  return showDialog(context: context, builder: (BuildContext context){
    return AlertDialog(title: const Text('Report Stolen Bike'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            cardImage(bike['image']),
            const Text("This bike will be reported Stolen and removed from the App."),

          ],

        ),

      ),
      actions: <Widget>[
        TextButton(child: const Text("Cancel"),
          onPressed: (){
            Navigator.of(context).pop();
          },),
        TextButton(
        child: const Text("Report Stolen",style: TextStyle(color: Colors.red),),
        onPressed: () async {
          await removeStolen(bikeid);

          Navigator.popUntil(context, ModalRoute.withName('/home'));
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Bike Removed from App'))
          );
        },),
      ],);


});}

removeStolen(bikeid) async {
  FirebaseFirestore.instance.collection('bikes').doc(bikeid).update({
    'cur_user': "",
    'available': false,
    'stolen': true,
  });
  FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).
  update({
    'bikeCheckedOut' : "",
  });
}