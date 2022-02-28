// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutterfire_ui/auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:bike_kollective/src_exports.dart';
//
// class AuthGate extends StatelessWidget {
//   const AuthGate({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final Map<String, String> env = Platform.environment;
//     final String clientID = env["googleCID"] ?? '1:8483216445:android:cb216fb471665ba13c9e54';
//
//     const List<ProviderConfiguration> providerConfigs = [
//       EmailProviderConfiguration(),
//       GoogleProviderConfiguration(clientId: '1:8483216445:android:cb216fb471665ba13c9e54')
//     ];
//
//     return MaterialApp(
//         theme: ThemeData(
//             textTheme: TextTheme(
//           headline5: GoogleFonts.pacifico(
//             textStyle: const TextStyle(
//               fontSize: 42,
//             ),
//           ),
//         )),
//         initialRoute:
//             FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/home',
//         routes: {
//           '/sign-in': (context) =>
//               const SignIn(providerConfigs: providerConfigs),
//           '/home': (context) => const NavBarPage(),
//           '/forgot-password': (context) => const BKForgotPassword(),
//           '/profile': (context) =>
//               ProfileScreen(providerConfigs: providerConfigs, actions: [
//                 SignedOutAction((context) {
//                   Navigator.of(context).pushReplacementNamed('/sign-in');
//                 }),
//               ])
//         });
//   }
// }
