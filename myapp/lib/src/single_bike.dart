import 'package:bike_kollective/src/checkoutBike.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:bike_kollective/src_exports.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SingleBike extends StatefulWidget {
  SingleBike({Key? key, this.bikeId}) : super(key: key);

  var bikeId;

  @override
  State<SingleBike> createState() => _SingleBikeState();
}

class _SingleBikeState extends State<SingleBike> {
  // Form key used for add tag form.
  final formKey = GlobalKey<FormState>();
  // Ensures user does not rate bike multiple times.
  bool rated = false;

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
            // Error generating snapshot.
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }
            // Would load if document had no data.
            if (snapshot.hasData && !snapshot.data!.exists) {
              return const Text("Document does not exist");
            }
            // Expected normal result. Displays bike data.
            if (snapshot.hasData) {
              Map<String, dynamic> data =
                  snapshot.data?.data() as Map<String, dynamic>;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 19.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40), // Image border
                        child: SizedBox.fromSize(
                            size: const Size.fromRadius(148), // Image radius

                            child: getImage(data['image'])),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shadowColor: Colors.blue,
                            elevation: 4.0),
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    checkoutBike(bikeId: snapshot.data?.id))),
                        child: const Text(
                          'Borrow This Bike!',
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Bangers',
                              color: Colors.deepPurpleAccent),
                        ),
                      ),
                      fieldRow("available", data['available']),
                      fieldRow("category", data['category']),
                      fieldRow("condition", data['condition']),
                      fieldRow("make", data['make']),
                      fieldRow("model", data['model']),
                      fieldRow("year", data['year']),
                      fieldRow("user rating", data['rating']),
                      const Text("Your Rating: "),
                      RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.deepPurpleAccent,
                        ),
                        onRatingUpdate: (rating) {
                          if (rated == false) {
                            BikeUpdate ratingUpdate =
                                BikeUpdate(bikeDocId: snapshot.data?.id);
                            ratingUpdate.updateBikeRating(rating,
                                data['rating'], data['numberOfRatings']);
                            setState(() {
                              rated = true;
                            });
                          } else {
                            showRatingDialog();
                          }
                        },
                      ),
                      Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: allTagsDisplay(data['tags'])),
                      Form(
                          key: formKey,
                          child: SetUpHelper.tagFormField(
                              "Add Tag", snapshot.data?.id, data['tags'])),
                      ElevatedButton(
                          onPressed: addTagPress, child: const Text("Add")),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: popRoute, child: const Text("Go Back")),
                      ),
                    ],
                  ),
                ),
              );
              // else, should only display while app is still waiting on intiial data from Firestore.
            } else {
              return const Text("Loading");
            }
          }),
    );
  }

  // Function to return back to bike list page.
  void popRoute() {
    Navigator.of(context).pop();
  }

  // Returns Row populated with formatted and stylized piece of data from bike document.
  Widget fieldRow(String fieldName, dataItem) {
    if (dataItem == null) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('$fieldName: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurpleAccent,
              )),
          const Text('N/A'),
        ]),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Field name row.
          Text('$fieldName: ',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Righteous',
              )),
          // Field data row.
          Text(dataItem.toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blue)),
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
      return Padding(
        padding: const EdgeInsets.only(bottom: 22),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('$fieldName: ',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          Text(dataItem.toString()),
        ]),
      );
    }
  }

  // Display a single tag from the bike's tag array.
  Widget singleTagDisplay(tag) {
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

  // Display all of bike's tags in a Column containing Rows consisting of 3 tagDisplays
  allTagsDisplay(tagList) {
    List<Widget> columnChildren = [];
    List<Widget> rowChildren = [];

    for (int i = 0; i < tagList.length; i++) {
      rowChildren.add(singleTagDisplay(tagList[i]));
      if ((i + 1) % 3 == 0) {
        columnChildren.add(
          Wrap(
            children: rowChildren,
            alignment: WrapAlignment.center,
          ),
        );
        rowChildren = [];
      }
    }
    columnChildren.add(
      Wrap(
        children: rowChildren,
        alignment: WrapAlignment.center,
      ),
    );
    return Column(
        mainAxisAlignment: MainAxisAlignment.center, children: columnChildren);
  }

  // Show dialog if user tries to rate bike multiple times.
  void showRatingDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => const AlertDialog(
            content: Text("You've already rated this bike.",
                style: TextStyle(fontWeight: FontWeight.bold))));
  }

  // Run when add tag button is pressed.
  void addTagPress() {
    if (formKey.currentState!.validate()) {
      // If all forms validated and waiver checked, save state.
      formKey.currentState!.save();
    }
  }

  // Return Firebase image if exists in database, otherwise display placeholder.
  Widget getImage(bikeImage) {
    if (bikeImage == "") {
      return const Image(
        image: AssetImage('assets/images/bike-icon.png'),
        width: 200,
        height: 200,
      );
    } else {
      return Image(
        image: FirebaseImage(
          bikeImage,
        ),
        width: 200,
        height: 200,
      );
    }
  }
}
