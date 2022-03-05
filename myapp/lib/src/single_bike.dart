import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:bike_kollective/src_exports.dart';

class SingleBike extends StatefulWidget {
  SingleBike({Key? key, required this.bikeDoc, this.bikeId}) : super(key: key);

  var bikeDoc;
  var bikeId;

  @override
  State<SingleBike> createState() => _SingleBikeState();
}

class _SingleBikeState extends State<SingleBike> {
  var bikeData;

  void initState() {
    super.initState();
    bikeData = widget.bikeDoc.data();
    print(bikeData['category']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('bikes')
              .doc(widget.bikeId)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            } else {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  bigRow("id", snapshot.data?.id),
                  Image(
                    image: FirebaseImage(
                      data['image'],
                    ),
                    width: 200,
                    height: 200,
                  ),
                  fieldRow("available", data['available']),
                  fieldRow("category", data['category']),
                  fieldRow("condition", data['condition']),
                  fieldRow("make", data['make']),
                  fieldRow("make", data['make']),
                  fieldRow("year", data['year']),
                  fieldRow("user rating", data['rating']),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        tagDisplay("old"),
                        tagDisplay('good tires'),
                        tagDisplay('heavy')
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: popRoute, child: Text("Go Back")),
                  ),
                ],
              );
            }
          }),
    );
    // return StreamBuilder(
    //     stream: FirebaseFirestore.instance
    //         .collection("bikes")
    //         .doc(widget.bikeId)
    //         .snapshots(),
    //     builder: (content, snapshot) {
    //       if (snapshot.hasData) {
    //         var bikeDocument = snapshot.data;
    //         return Scaffold(
    //           body: Column(
    //             children: [
    //               Text(snapshot.data?.get('category')),
    //               ElevatedButton(onPressed: popRoute, child: Text("Go Back")),
    //             ],
    //           ),
    //         );
    //       } else {
    //         return Scaffold(
    //           body: Column(
    //             children: [
    //               ElevatedButton(onPressed: popRoute, child: Text("Go Back")),
    //               //Text("widget.bikeDoc['Category']"),
    //               Text(bikeData['category'])
    //             ],
    //           ),
    //         );
    //       }
    //     });
  }

  // Function to return back to bike list page.
  void popRoute() {
    Navigator.of(context).pop();
  }

  Widget fieldRow(String fieldName, dataItem) {
    if (dataItem == null) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('$fieldName: ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const Text('N/A'),
        ]),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('$fieldName: ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(dataItem.toString()),
        ]),
      );
    }
  }

  Widget bigRow(String fieldName, dataItem) {
    if (dataItem == null) {
      return Padding(
        padding: const EdgeInsets.only(),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('$fieldName: ',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          const Text('N/A'),
        ]),
      );
    } else {
      return Container(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 22),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('$fieldName: ',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            Text(dataItem.toString()),
          ]),
        ),
      );
    }
  }

  Widget tagDisplay(tag) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 5.0,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
