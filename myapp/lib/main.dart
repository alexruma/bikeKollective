import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'src_exports.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



void main() async{
  // Setting need to start firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bike Kollective',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headline5: GoogleFonts.pacifico(
            textStyle: const TextStyle(
              fontSize: 42,
            )
          )
        )
      ),
      home: const AuthGate(),
    );
  }
}
