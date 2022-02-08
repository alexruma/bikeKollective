<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bike_kollective/src_exports.dart';

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
=======
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bike_kollective/src_exports.dart';



class AuthGate extends StatelessWidget {
  const AuthGate({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    final Map<String, String>env = Platform.environment;
    final String clientID = env["googleCID"] ?? '';
    
    const List<ProviderConfiguration> providerConfigs = [
      EmailProviderConfiguration(), 
      GoogleProviderConfiguration(
        clientId: ''
      )
    ];

    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          headline5: GoogleFonts.pacifico(
            textStyle: const TextStyle(
              fontSize: 42,
            ),
          ),
        )
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/profile',
      routes: {
        '/sign-in': (context) => const SignIn(
          providerConfigs: providerConfigs
        ),
        '/home' : (context) => const Gmaps(),
        '/forgot-password' : (context) => const BKForgotPassword(),
        '/profile' : (context) => ProfileScreen(
          providerConfigs: providerConfigs,
          actions: [
            SignedOutAction((context) {
              Navigator.of(context).pushReplacementNamed('/sign-in');
            }),
          ]
        )
      }
    );
  }
}




>>>>>>> origin/main
