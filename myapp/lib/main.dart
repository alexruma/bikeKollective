import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'src_exports.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  // Setting need to start firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
  // This widget is the root of your application.

}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    const List<ProviderConfiguration> providerConfigs = [
      EmailProviderConfiguration(),
      GoogleProviderConfiguration(clientId: '')
    ];
    return MaterialApp(
      routes: {
        '/sign-in': (context) => const SignIn(providerConfigs: providerConfigs),
        '/home': (context) => const NavBarPage(),
        '/forgot-password': (context) => const BKForgotPassword(),
        '/profile': (context) =>
            ProfileScreen(providerConfigs: providerConfigs, actions: [
              SignedOutAction((context) {
                Navigator.of(context).pushReplacementNamed('/sign-in');
              }),
            ])
      },
      title: 'Bike Kollective',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
              headline5: GoogleFonts.pacifico(
                  textStyle: const TextStyle(
            fontSize: 42,
          )))),
      home: const AuthGate(),
    );
  }
}
