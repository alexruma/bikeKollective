import 'package:bike_kollective/helpers/add_bike_image.dart';
import 'package:flutter/material.dart';

class BikeImage {

  String _url = '';

  BikeImage();


  Future<Icon> get photo async {
    return _url == '' ? 
      const Icon(Icons.image_not_supported, size: 40) 
      : Icon(Icons.check_rounded, size: 40);
    
    //_url == '' ? const Icon(Icons.image) : Image.network(_url);
  }

  String get url => _url;

  void addPhoto() {
    uploadPic().then( (String url) {
      _url = url;
      // print(url);
    });
  }

}