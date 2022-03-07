
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'src_exports.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

const CLIENT_ID_PATH = 'assets/keys/google_client_id.txt';

void main() async {
  // Setting need to start firebase
  WidgetsFlutterBinding.ensureInitialized();
  String clientID = await rootBundle.loadString(CLIENT_ID_PATH);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(clientID: clientID));
}

class MyApp extends StatefulWidget {

  final String clientID = '';

  const MyApp({Key? key, required clientID}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
  // This widget is the root of your application.

}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    List<ProviderConfiguration> providerConfigs = [
      EmailProviderConfiguration(),
      GoogleProviderConfiguration(clientId: widget.clientID)
    ];
    return MaterialApp(
      routes: {
        '/sign-in': (context) => SignIn(providerConfigs: providerConfigs),
        '/home': (context) => const NavBarPage(),
        '/forgot-password': (context) => const BKForgotPassword(),
        '/profile': (context) =>
            ProfileScreen(providerConfigs: providerConfigs, actions: [
              SignedOutAction((context) {
                Navigator.of(context).pushReplacementNamed('/sign-in');
              }),
            ]),
      },
      title: 'Bike Kollective',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
              headline5: GoogleFonts.pacifico(
                  textStyle: const TextStyle(
            fontSize: 42,
          )))),
      // home: const AuthGate(),
      initialRoute:
      FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/home',
    );
  }
}
