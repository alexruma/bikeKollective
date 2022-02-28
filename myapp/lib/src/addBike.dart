import 'package:bike_kollective/helpers/add_bike_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/uploadedImage.dart';

class BikeFields {
  String model = '';
  String make = '';
  String condition = '';
  String category = '';
  String lock = '';
  int year = 2022;
}

class AddBike extends StatefulWidget {

  

  const AddBike({ Key? key }) : super(key: key);

  @override
  State<AddBike> createState() => _AddBikeState();
}

class _AddBikeState extends State<AddBike> {
  
  final bikeImage = BikeImage();
  final _formKey = GlobalKey<FormState>();
  final bike = BikeFields();

  Future<void> _dateSelector(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2022),
      firstDate: DateTime(1900),lastDate: DateTime(2025),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null) {
      setState(() {
        bike.year = int.parse(DateFormat('yyyy').format(picked));
      });
    }
  }

  Widget _yearSelector () {
    return AlertDialog(
      title: Text('Select Year'),
      content: Container(
        width: 300,
        height: 300,
        child: YearPicker(
          firstDate: DateTime(DateTime.now().year - 100, 1),
          lastDate: DateTime(DateTime.now().year + 100, 1),
          initialDate: DateTime.now(),
          selectedDate: DateTime.now(),
          onChanged: (DateTime dateTime) {
            bike.year = int.parse(DateFormat('yyyy').format(dateTime));
            Navigator.pop(context);
          },
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                )
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textForm('Make', bike.make),
                    const SizedBox(height: 10),
                    textForm('Model', bike.model),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Year: ' + bike.year.toString(),
                            style: TextStyle(
                              fontSize: 24
                            )
                          ),
                        ),
                        // Container(
                        //   child: Text(bike.year.toString()),
                        //   decoration: BoxDecoration(
                        //     border: Border.all(color: Colors.grey)
                        //   )
                        // ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.indigo
                          ),
                          onPressed: (){
                            showDialog(
                              context: context,
                              builder: (context) {
                                return _yearSelector();
                              }
                            );
                          },
                          child: const Text('Select Year')
                        ),
                        
                      ],
                    ),
                    const SizedBox(height: 10),
                    textForm('Condition', bike.condition),
                    const SizedBox(height: 10),
                    textForm('Category', bike.category),
                    const SizedBox(height: 10),
                    textForm('Lock Combo', bike.lock),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          onPressed: () { setState(() =>  bikeImage.addPhoto()); },
                          icon: const Icon(Icons.camera_alt, size: 40)
                        ),
                        // Container(child: bikeImage.photo),
                        FutureBuilder(
                          future: bikeImage.photo,
                          builder: (context, dynamic snapshot) {
                            // print(snapshot.data);
                            if (snapshot.connectionState == ConnectionState.done) {
                              return snapshot.data;
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                        onPressed: () {},
                        child: const Text('Submit'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        )
                      ]
                    )
                  ]
                )
              ),
            ),
            
          ],
    ),
      ));
  }

  Widget textForm(String label, dynamic saveLoc) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      onSaved: (newVal) {
        saveLoc = newVal ?? '';
      },
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      )
    );
  }
}

