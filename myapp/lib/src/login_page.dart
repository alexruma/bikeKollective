import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bike_kollective/src_exports.dart';



class LoginPage extends StatefulWidget {
   const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
 main
  @override
  Widget build(BuildContext context){
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
      home: SignInScreen(
                    subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  action == AuthAction.signIn
                    ? 'Please sign in to continue.'
                    : 'Please create an account to continue.'
                ),
              );
            },
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset('assets/images/rider-bike-icon.png'),
                ),
              );
            },
            providerConfigs: const [
              EmailProviderConfiguration(),
              GoogleProviderConfiguration(
                clientId: '1:8483216445:android:cb216fb471665ba13c9e54',
              ),
            ],
      ),
    );
  }
}