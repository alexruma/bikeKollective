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
  // Temp User Map
  Map tempUser = {
    'userID': '123456',
    'firstName': "Pete",
    'lastName': "Pizza",
    'email': 'bada@bing.com',
  };

  // Text Field Controllers.
  final nameController = TextEditingController();
  final emailController = TextEditingController();

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
              Expanded(
                child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    )),
              ),
              // Email Row
              Row(children: [
                accountItemText("Email Address:"),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text('Replace with name from DB'),
                ),
                editAccountItem()
              ]),
              Expanded(
                child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    )),
              ),
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
        floatingActionButton: FloatingActionButton(onPressed: () {
          setState(() {
            tempUser['firstName'] = nameController.text;
            tempUser['email'] = emailController.text;
            print(tempUser);
            UserModel newUserModel = createUserModel(tempUser);
            print(newUserModel.firstName);
            var addUser = AddUser(userModel: newUserModel);
          });
        }));
  }

  // Create new user model
  UserModel createUserModel(var tempMap) {
    UserModel newUser = UserModel(tempMap['userID'], tempMap['firstName'],
        tempMap['lastName'], tempMap['email']);
    return newUser;
  }

  // Widgets.
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
