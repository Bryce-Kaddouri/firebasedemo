import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebasedemo/screens/authentification/signin/signin.dart';
import 'package:flutter/material.dart';

import 'decorations.dart';

class EmailCheck extends StatefulWidget {
  const EmailCheck({super.key});

  @override
  State<EmailCheck> createState() => _EmailCheckState();
}

class _EmailCheckState extends State<EmailCheck> {

  @override
  Widget build(BuildContext context) {
    return EmailVerificationScreen(
      headerBuilder: headerIcon(Icons.verified),
      sideBuilder: sideIcon(Icons.verified),
      actionCodeSettings: actionCodeSettings,
      actions: [
        EmailVerifiedAction(() {
          Navigator.pushReplacementNamed(context, '/profile');
        }),
        AuthCancelledAction((context) {
          FirebaseUIAuth.signOut(context: context);
          Navigator.pushReplacementNamed(context, '/');
        }),
      ],
    );
  }
}
