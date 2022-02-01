import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bike_kollective/src_exports.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key, required this.title}) : super(key: key);

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<LoginPage> createState() => _LoginState();
// }

// class _LoginState extends State<LoginPage> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         resizeToAvoidBottomInset: true,
//         appBar: AppBar(
//           title: const Center(child: Text("Login")),
//         ),
//         bottomNavigationBar: NavBar.navBar(),
//         body: Center(
//           child: Column(
//             children: <Widget>[
//               Expanded(
//                 child: Image.asset(
//                   'assets/images/rider-bike-icon.png',
//                   height: 200,
//                   width: 200,
//                 ),
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.all(25),
//                   child: Text(
//                     "Sign in",
//                     style: GoogleFonts.pacifico(
//                         textStyle: const TextStyle(
//                       fontSize: 34,
//                     )),
//                   ),
//                 ),
//               ),
//               headlineText("Email Address"),
//               Expanded(child: inputField('Enter Email Address'), flex: 1),
//               headlineText("Password"),
//               Expanded(child: passwordField('Enter Password'), flex: 1),
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.blueAccent),
//                   borderRadius: const BorderRadius.all(Radius.circular(5.0)),
//                 ),
//                 child: TextButton(
//                   onPressed: () {
//                     //TODO FORGOT PASSWORD SCREEN GOES HERE
//                   },
//                   child: const Text(
//                     'Forgot Password',
//                     style: TextStyle(color: Colors.blue, fontSize: 15),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }

//   Widget headlineText(widgetText) {
//     return Expanded(
//       child: Align(
//           alignment: Alignment.bottomCenter,
//           child: Padding(
//               padding: EdgeInsets.all(10),
//               child: Text(
//                 widgetText,
//                 style: Theme.of(context).textTheme.headline6,
//               ))),
//     );
//   }

//   Widget inputField(labelText) {
//     return Padding(
//       padding: const EdgeInsets.all(2),
//       child: TextField(
//         decoration: InputDecoration(
//           border: const OutlineInputBorder(),
//           labelText: labelText,
//         ),
//       ),
//     );
//   }

//   Widget passwordField(labelText) {
//     return Padding(
//       padding: const EdgeInsets.all(2),
//       child: TextField(
//         obscureText: true,
//         decoration: InputDecoration(
//           border: const OutlineInputBorder(),
//           labelText: labelText,
//         ),
//       ),
//     );
//   }
// }



// class CustomSignInWidget extends StatelessWidget {
//   const CustomSignInWidget({ Key? key }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomEmailSignInForm(),
//     );
//   }
// }

// class CustomEmailSignInForm extends StatelessWidget {
//   CustomEmailSignInForm({ Key? key }) : super(key: key);

//   final emailCtrl = TextEditingController();
//   final passwordCtrl = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return AuthFlowBuilder<EmailFlowController>(
//       builder: (context, state, controller, _) {
//         if (state is AwaitingEmailAndPassword) {
//           return Scaffold(
//             resizeToAvoidBottomInset: false,
//             appBar: AppBar(
//               title: const Center(child: Text("Login")),
//             ),
//             bottomNavigationBar: NavBar.navBar(),
//             body: Column(
//               children: [
//                 Expanded(
//                   child: Image.asset('assets/images/rider-bike-icon.png',
//                   height: 100,
//                   width: 100,)
//                 ),
//                 Text(
//                       "Sign in",
//                       style: GoogleFonts.pacifico(
//                         textStyle: const TextStyle(
//                           fontSize: 34,
//                         )
//                       ),
                  
//                 ),
                
//                 TextField(
//                   controller: emailCtrl,
//                   decoration: const InputDecoration(
//                     labelText: "Email",
//                   ),
//                 ),
//                 TextField(controller: passwordCtrl),
//                 ElevatedButton(
//                   onPressed: () {
//                     controller.setEmailAndPassword(
//                       emailCtrl.text,
//                       passwordCtrl.text,
//                     );
//                   },
//                   child: const Text('Sign in'),
//                 ),
//               ],
//             )
//           );
//         } else if (state is SigningIn) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (state is AuthFailed) {
//           return ErrorText(exception: state.exception);
//         }
//         return CustomEmailSignInForm();
//       },
//     );
//   }
// }



class SignIn extends StatelessWidget {
  const SignIn({ Key? key }) : super(key: key);

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