import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bike_kollective/src_exports.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<CreateAccountPage> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Center(child: Text("Create Account")),
        ),
        bottomNavigationBar: NavBar.navBar(),
        body: Center(
          child: ListView(
            children: <Widget>[
              // Expanded(
              //   child: Image.asset(
              //     'assets/images/rider-bike-icon.png',
              //     height: 200,
              //     width: 200,
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.all(25),
                child: Text(
                  "Create New Account",
                  style: GoogleFonts.pacifico(
                      textStyle: const TextStyle(
                    fontSize: 34,
                  )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Image.asset(
                    'assets/images/btn_google_signin_dark_normal_web.png',
                    height: 100,
                    width: 100),
              ),
              headlineText("Email Address"),
              inputField('Enter Email Address'),
              headlineText("Password"),
              passwordField('Enter Password'),
              passwordField('Confirm Password'),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: TextButton(
                  onPressed: () {
                    //TODO FORGOT PASSWORD SCREEN GOES HERE
                  },
                  child: const Text(
                    'Create Account',
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget headlineText(widgetText) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              widgetText,
              style: Theme.of(context).textTheme.headline6,
            )));
  }

  Widget inputField(labelText) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
        ),
      ),
    );
  }

  Widget passwordField(labelText) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
        ),
      ),
    );
  }
}
