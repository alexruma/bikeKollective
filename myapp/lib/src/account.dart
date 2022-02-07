import 'package:flutter/material.dart';
import 'package:bike_kollective/src_exports.dart';

class AccountPage extends StatefulWidget {
  AccountPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: const EdgeInsets.all(12.0),
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/alex.jpg'),
              ),
            ),
            // Name Row.
            Row(children: [
              accountItemText("Name:"),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('Replace with name from DB'),
              ),
              editAccountItem()
            ]),
            // Email Row
            Row(children: [
              accountItemText("Email Address:"),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('Replace with name from DB'),
              ),
              editAccountItem()
            ]),
            Row(children: [
              accountItemText("Current Bike:"),
              GestureDetector(
                onTap: () {
                  //TODO: add bike link functionality
                },
                child: Text('Bike Name/ID',
                    style: TextStyle(color: Colors.lightBlue)),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget accountItemText(String itemText) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Text(itemText, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget editAccountItem() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          //TODO: add edit functionality
        },
        child: Text('Edit', style: TextStyle(color: Colors.lightBlue)),
      ),
    );
  }
}
