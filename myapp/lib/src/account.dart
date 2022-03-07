import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bike_kollective/src_exports.dart';
import 'package:intl/intl.dart';

import '../models/cardImage.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key? key,}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  CollectionReference bike = FirebaseFirestore.instance.collection('bikes');
  Map<String, dynamic> bikeinfo = {};

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Map<String, dynamic> userinfo = {};

  Future<Map<String, dynamic>> getUserInfo() async {
    return await users.doc(FirebaseAuth.instance.currentUser?.uid).get().then((DocumentSnapshot value){
      userinfo = value.data() as Map<String, dynamic>;
      return userinfo;
    });
  }

  
  OwnedBikes(user){
    return FutureBuilder(
        future: bike.where('owner', isEqualTo: FirebaseAuth.instance.currentUser?.uid).get(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
          if(!snapshot.hasData){
            return const Center(child: CircularProgressIndicator());
          }
          if(!snapshot.hasData){
            return const Center(child: CircularProgressIndicator());
          }
          var items = snapshot.data?.docs;
          // print(items!.id);
          if(items.length == 0){
            return const Center(child: Text("No Bikes Currently owned"));
          }
          return ListView.builder(
            scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index){
              return ListTile(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=> SingleBike( bikeId: items[index].id, )));
                },
                leading: FittedBox(
                    fit: BoxFit.contain,
                    child: cardImage(items[index]['image'])),
                title: Text("Type: ${items[index]['category']}"),
                subtitle: Text("Year: ${items[index]['year']}"),
              );
          });});
  }


  CurrentBike(user){
      if(user['bikeCheckedOut']!=""){
    return FutureBuilder(
        future: bike.doc(user['bikeCheckedOut']).get(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
          if(!snapshot.hasData){
            return const Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasData && !snapshot.data!.exists){
            return(const Text("No Bike Currently Checked Out"));
            }
          return Row(
            children: [
              Expanded(child: ListTile(
                onTap: (){
                  //TODO: View Bike
                  Navigator.push(context,MaterialPageRoute(builder: (context)=> SingleBike( bikeId: snapshot.data.id, )));

                },
                leading: FittedBox(
                    fit: BoxFit.contain,
                    child: cardImage(snapshot.data['image'])),
                title: Text("Type: ${snapshot.data['category']}"),
              subtitle: Text("Year: ${snapshot.data['year']}\n"
                  "Bike Return Time: "
                  "${DateFormat.jm().format(snapshot.data['checkoutTime']
                  .toDate().add(const Duration(hours: 8)))}"),)),
            ],
          );
        });
  }
  else{
    return const Center(child: (Text("No Bike Currently Checked Out",
      style: TextStyle(fontSize: 16),)));
      }
  }

  UserData(user) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("${user['firstName']} ${user["lastName"]}"
              ,style: const TextStyle(fontSize: 18),),

              ],)
            ,
          ),
        Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("Email: ${user['email']}",
        style: TextStyle(fontSize: 16),)],),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red)
                  ),
                  child: const Text("LogOut"),
                 onPressed: (){
                   signOutAction();
                 }, ),
            )
          ],
        ),

        Row(mainAxisAlignment: MainAxisAlignment.center,
        children: const [Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Current Bike",style: TextStyle(fontSize: 20)),
        )],),
        Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [Container(
          width: 300,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black)
          ),
          child: CurrentBike(user),
        )],),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Owned Bikes", style: TextStyle(fontSize: 20),)
          ],),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: OwnedBikes(user),
          )
        ],)],
      ),
    );


  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserInfo(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
          if(!snapshot.hasData){
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else{
            return Scaffold(

                body: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [UserData(snapshot.data),

                      ],
                    ),
                  ),

                ),
            );
          }
        });}

  void signOutAction() {
    FirebaseAuth.instance.signOut();
    setState(() {});
    Navigator.of(context).pushReplacementNamed('/sign-in');
  }
  }

