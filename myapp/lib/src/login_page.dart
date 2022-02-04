import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bike_kollective/src_exports.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Center(child: Text("Login")),
        ),
        bottomNavigationBar: NavBar.navBar(),
        body: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Image.asset(
                  'assets/images/rider-bike-icon.png',
                  height: 200,
                  width: 200,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    "Sign in",
                    style: GoogleFonts.pacifico(
                        textStyle: const TextStyle(
                      fontSize: 34,
                    )),
                  ),
                ),
              ),
              headlineText("Email Address"),
              Expanded(child: inputField('Enter Email Address'), flex: 1),
              headlineText("Password"),
              Expanded(child: passwordField('Enter Password'), flex: 1),
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
                    'Forgot Password',
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget headlineText(widgetText) {
    return Expanded(
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                widgetText,
                style: Theme.of(context).textTheme.headline6,
              ))),
    );
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
