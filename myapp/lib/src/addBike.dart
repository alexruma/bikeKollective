import 'package:bike_kollective/helpers/add_bike_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/uploadedImage.dart';

class AddBike extends StatefulWidget {

  

  const AddBike({ Key? key }) : super(key: key);

  @override
  State<AddBike> createState() => _AddBikeState();
}

class _AddBikeState extends State<AddBike> {
  
  final bikeImage = BikeImage();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bike')
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Add Bike',
              style: 
                GoogleFonts.pacifico(
                  textStyle: const TextStyle(fontSize: 48)
                )),
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: () { setState(() =>  bikeImage.addPhoto()); },
                  // () {
                  //   uploadPic().then( (String url) {
                  //     picURL = url;
                  //   });
                  //   //picURL = uploadPic();
                  //   // print(picURL);
                  // },
                  icon: const Icon(Icons.camera_alt)
                ),
                // Container(child: bikeImage.photo),
                FutureBuilder(
                  future: bikeImage.photo,
                  builder: (context, dynamic snapshot) {
                    print(snapshot.data);
                    if (snapshot.connectionState == ConnectionState.done) {
                      return snapshot.data;
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ],
            )
          ],
    ),
      ));
  }
}

