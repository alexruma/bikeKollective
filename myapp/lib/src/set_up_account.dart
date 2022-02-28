import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bike_kollective/src_exports.dart';

class SetUpPage extends StatefulWidget {
  const SetUpPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SetUpPage> createState() => _SetUpPageState();
}

class _SetUpPageState extends State<SetUpPage> {
  final formKey = GlobalKey<FormState>();

  // Map that acts as temp object to hold form input and then is passed as argument for UserModel constructor.
  Map<String, String?> userMap = {
    "userID": FirebaseAuth.instance.currentUser?.uid
  };

  // Bool that remains false unless user has checked box stating they agree to waiver.
  bool waiverAgree = false;
  //UserModel userModel = UserModel( FirebaseAuth.instance.currentUser?.uid, FirebaseAuth.instance.currentUser?.email);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // This line disables the back button.
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            title: const Center(
                child: Padding(
              padding: EdgeInsets.all(2.0),
              child: Text("Set Up"),
            )),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: signOutAction,
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Center(
                child: Column(
              children: [
                const Text("Set Me Up"),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SetUpHelper.customFormFieldText(
                          "First Name", "firstName", userMap),
                      SetUpHelper.customFormFieldText(
                          "Last Name", "lastName", userMap),
                      SetUpHelper.customFormFieldPhone(
                          "Cell Phone Number", "phoneNumber", userMap),
                      SetUpHelper.customFormFieldText(
                          "Date of Birth", "dob", userMap),
                      Row(
                        children: [
                          const Text(
                              "Please acknowledge that you agree to our "),
                          GestureDetector(
                              child: const Text(
                                "Terms of Use",
                                style: TextStyle(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () => showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                          content: Text(SetUpHelper.waiverText,
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold)))))
                        ],
                      ),
                      Checkbox(
                        value: waiverAgree,
                        onChanged: (value) {
                          setState(() {
                            waiverAgree = value ?? false;
                          });
                        },
                      ),
                      ElevatedButton(
                          onPressed: doneButtonPress,
                          child: const Text(
                            "Done",
                          ))
                    ],
                  ),
                )
              ],
            )),
          )),
    );
  }

  // Function that executes on tap of Sign Out button/text.
  void signOutAction() {
    FirebaseAuth.instance.signOut();
    setState(() {});
    Navigator.of(context).pushReplacementNamed('/forgot-password');
  }

  // Function to return back to homepage.
  void popRoute() {
    Navigator.of(context).pop();
  }

  // Function to be executed when done button is pressed after form is filled.
  void doneButtonPress() {
    if (formKey.currentState!.validate()) {
      // Check that waiver has been agreed to.
      if (waiverAgree == true) {
        // If all forms validated and waiver checked, save state.
        formKey.currentState!.save();
        // Create new UserModel with data collected.
        var newUserModel = UserModel(userMap);
        // Create new document in Firestore based on newUserModel.
        var newUserAdd = AddUser(userModel: newUserModel);
        // Return to main page.
        popRoute();
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) => const AlertDialog(
                content: Text(
                    "You must check the box verify that you agree to our terms of use.")));
      }
    }
  }
}
