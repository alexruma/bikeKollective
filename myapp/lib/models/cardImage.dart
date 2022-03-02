import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';

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