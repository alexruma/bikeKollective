import 'package:bike_kollective/helpers/add_bike_image.dart';
import 'package:flutter/material.dart';

class BikeImage {

  String _url = '';

  BikeImage();


  Icon get photo {
    return _url == '' ? 
      const Icon(Icons.image_not_supported, size: 40) 
      : const Icon(Icons.check_rounded, size: 40);
  }

  String get url => _url;

  Future<void> addPhoto(BuildContext context) async {
    await uploadPic(context).then( (String url) {
      _url = url;
      // print(url);
    });
    
  }
}