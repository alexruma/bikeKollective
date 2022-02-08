import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class SignIn extends StatelessWidget {

  final List<ProviderConfiguration> providerConfigs;

  const SignIn({ Key? key, required this.providerConfigs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      subtitleBuilder: (context, action) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            action == AuthAction.signIn
              ? 'Please sign in to continue.'
              : 'Please create an account to use the app.'
          )
        );
      },
      headerBuilder: (context, constraints, _) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset('assets/images/rider-bike-icon.png'),
          )
        );
      },
      providerConfigs: providerConfigs,
      actions: [
        AuthStateChangeAction<SignedIn>((context, _) {
          Navigator.of(context).pushReplacementNamed('/profile');
        }),
        ForgotPasswordAction((context, email) {
          Navigator.of(context).pushNamed(
            '/forgot-password',
            arguments: {'email': email},
          );
        })
      ],
    );
  }
}



class BKForgotPassword extends StatelessWidget {
  const BKForgotPassword({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ForgotPasswordScreen(
      headerBuilder:(context, constraints, shrinkOffset) {
        return Padding(
          padding: const EdgeInsets.all(20).copyWith(top: 40),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset('assets/images/rider-bike-icon.png')),
        );
      },      
    );
  }
}