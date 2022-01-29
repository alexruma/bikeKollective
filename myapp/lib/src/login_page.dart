import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Login")),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/images/rider-bike-icon.png',
              height: 200,
              width: 200,
            ),
            Padding(
                padding: EdgeInsets.all(30),
                child: Text(
                  "Sign in",
                  style: GoogleFonts.pacifico(
                      textStyle: TextStyle(
                    //fontStyle: FontStyle.italic,
                    fontSize: 34,
                  )),
                )),
            headlineText("Email Address"),
            headlineText("Password"),
          ],
        ),
      ),
    );
  }

  Widget headlineText(widgetText) {
    return Padding(
        padding: EdgeInsets.all(30),
        child: Text(
          widgetText,
          style: Theme.of(context).textTheme.headline5,
        ));
  }
}
