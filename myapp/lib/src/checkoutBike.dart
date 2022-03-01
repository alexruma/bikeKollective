import 'package:bike_kollective/src/stolenBike.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../src_exports.dart';

class checkoutBike extends StatefulWidget {
  checkoutBike({Key? key, required this.bikeId}) : super(key: key);
  String bikeId;

  @override
  _checkoutBikeState createState() => _checkoutBikeState();
}

class _checkoutBikeState extends State<checkoutBike> {

  //Get Bike Info
  CollectionReference bike = FirebaseFirestore.instance.collection('bikes');
  Map<String, dynamic> bikeinfo = {};

  //Get User Info
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Map<String, dynamic> userinfo = {};

  Future<Map<String, dynamic>> getBikeInfo () async {
    return await bike.doc(widget.bikeId).get().then((DocumentSnapshot value){
      bikeinfo = value.data() as Map<String, dynamic>;
      // print(bikeinfo);
      return bikeinfo;
    }
    );
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    return await users.doc(FirebaseAuth.instance.currentUser?.uid).get().then((DocumentSnapshot value){
      userinfo = value.data() as Map<String, dynamic>;
      // print(userinfo);
      return userinfo;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget cardImage(image){
    if(image == ""){
      return const Image(image: AssetImage('assets/images/bike-icon.png'),
        width: 200,
        height: 100
        ,);
    } else{
      return Image(image: FirebaseImage(image),
        width: 300,
        height: 200
        ,);
    }
  }

  checkout(){
    if(userinfo["bikeCheckedOut"] == "" && bikeinfo["available"] == true){

      bike.doc(widget.bikeId).update({'available': false,
                          'cur_user': FirebaseAuth.instance.currentUser?.uid,
                          'checkoutTime': Timestamp.now()
      });
      users.doc(FirebaseAuth.instance.currentUser?.uid).update({
                 'bikeCheckedOut': widget.bikeId,
      });
      return showDialog(
        useRootNavigator: false,
        context: context,
        builder: (BuildContext context){
        return AlertDialog(title: const Text("Bike Checked Out"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [Text("Your bike is checked out. Use the following code to "
                  "unlock the bike.\n"
                  "Lock Combo: ${bikeinfo['lock']}")],
            ),
          ),
          actions: <Widget>[TextButton(child: const Text("Exit"),
          onPressed: (){
            // Pop two screens to return to map screen.
            // Works but there is a better way of doing this.

            Navigator.popUntil(context, ModalRoute.withName('/home'));
            },)],
        );},
      );
    }
  }

  review(context, reviewslist){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height:50,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: reviewslist.length,
              itemBuilder: (context, index){
                return Text("${index+1}. ${reviewslist[index]}")
                ;
              }),
        ),
      ),
    );
    }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([getBikeInfo(),getUserInfo()]),
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(!snapshot.hasData){
          return Scaffold(
              appBar: AppBar(title: const Text("Checkout Bike"),),
              body: const Center(child: CircularProgressIndicator()));
    }else{
          return Scaffold(
              appBar: AppBar(title: const Text("Checkout Bike"),),
              body: SingleChildScrollView(
                child: Center(
                    child: Column(
                      children: [
                        cardImage(snapshot.data[0]['image']),
                        Row( mainAxisAlignment: MainAxisAlignment.center,
                            children:
                              [RatingStar(rating: snapshot.data[0]['rating'],)]),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                          const Text("Type: ",style: TextStyle(fontWeight: FontWeight.bold),),
                          Text("${snapshot.data[0]['category']}"),
                          const Text(" Year: ",style: TextStyle(fontWeight: FontWeight.bold),),
                          Text("${snapshot.data[0]['year']}"),
                          const Text(" Condition: ",style: TextStyle(fontWeight: FontWeight.bold),),
                          Text("${snapshot.data[0]['condition']}")]),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          const Text("Make: ",style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('${snapshot.data[0]['make']}'),
                          const Text(" Model: ",style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('${snapshot.data[0]['model']}')
                        ],),

                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          const Text("Tags: ",style: TextStyle(fontWeight: FontWeight.bold),),
                          Text("${snapshot.data[0]['tags']}",
                            overflow: TextOverflow.fade,)
                        ],),

                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(child: const Text("Checkout Bike"),
                              onPressed: (){
                              checkout();
                              }, ),
                          ElevatedButton(
                            child: const Text("Report Stolen"),
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
                            onPressed: (){
                              stolenBike(context, snapshot.data[0], widget.bikeId);
                            }, ),

                          ],
                        ),
                        // Row(mainAxisAlignment: MainAxisAlignment.center,  children:[ review(context,snapshot.data[0]['reviews'])])

                      ],
                    )),
              ));
    }


    },
    );

}}
