import 'dart:async';
import 'package:bike_kollective/models/dropdown_rating_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/cupertino.dart';
import '../src_exports.dart';

class returnBike extends StatefulWidget {
  returnBike({Key? key, required this.bikeId}) : super(key: key);
  String bikeId;


  @override
  _returnBikeState createState() => _returnBikeState();
}

  class _returnBikeState extends State<returnBike> {

  Location location = Location();
  late LocationData _locationData;

  @override
  void initState() {
    super.initState();
  }
  final _returnFormKey = GlobalKey<FormState>();
  final bikeReturnFields = ReturnBikeFields();


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

  bikeReturnButton()async {
    bike.doc(widget.bikeId).update({'available': true,
                'cur_user':"",
                'rating': bikeReturnFields.rating,
    'location':GeoPoint(_locationData.latitude??0.0,_locationData.longitude??0.0),
    if(bikeReturnFields.review!="")"reviews" :FieldValue.arrayUnion([bikeReturnFields.review]) });
    users.doc(FirebaseAuth.instance.currentUser?.uid).update({
      'bikeCheckedOut': "",
      'checkoutTime': FieldValue.delete()
    });
    return showDialog(context: context,
        useRootNavigator: false,
        builder: (BuildContext context){
        return AlertDialog(title: const Text("Bike Returned"),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
                Text("Your Bike has been returned. Please lock up your bike."
                    "Thanks for using BikeKollective! ")
              ],
            ),
          ),
        actions: <Widget>[TextButton(child: const Text("Exit"),
          onPressed: (){
          Navigator.of(context).pop();
          Navigator.of(context).pop();

          },)
          ],
          );
        });
  }


  
  
  @override
  Widget build(BuildContext context) {
    return Form(key: _returnFormKey,
    child: FutureBuilder(
      future: Future.wait([getBikeInfo(), getUserInfo()]),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
        if(!snapshot.hasData){
          return Scaffold(
            appBar: AppBar(title: const Text("Return Bike"),),
                body: const Center(child: CircularProgressIndicator(),),
          );
        }
        else{
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(title: const Text("Return Bike")),
            body: SingleChildScrollView(
              child: Center(
                child:  Column(
                  children: [

                    cardImage(snapshot.data[0]['image']),
                    const Text("Current Rating"),
                    Row( mainAxisAlignment: MainAxisAlignment.center,
                        children:
                        [RatingStar(rating: snapshot.data[0]['rating'],)]),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownRatingFormField(maxRating: 5, validator: (value){
                            if(value == null){
                              return 'Please select a rating';
                            }
                          }, onSaved: (value){
                            bikeReturnFields.rating = value;
                          }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          
                          child: TextFormField(minLines: 2,
                                          maxLines: 5,
                            decoration: const InputDecoration(
                              hintText: 'Leave a bike review here.',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10))
                              )
                            ),
                            onSaved: (value){
                            bikeReturnFields.review = value??"";
                            },
                          ),
                        ),
                    ElevatedButton(
                        child: const Text("Return Bike"),
                      onPressed: () async{

                          if(_returnFormKey.currentState!.validate()){
                            _returnFormKey.currentState?.save();
                            _locationData = await location.getLocation();
                            bikeReturnButton();

                          }
                      }, )

                  ],
                ),
              ),
            ),
          );
        }
      },
    ),);
  }
}

class ReturnBikeFields {
  late int rating;
  late String review;
}
