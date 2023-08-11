// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart'
    hide PhoneAuthProvider, EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
/*
import 'package:firebase_ui_oauth_apple/firebase_ui_oauth_apple.dart';
*/
/*
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
*/
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebasedemo/screens/authentification/signin/config.dart';
import 'package:firebasedemo/screens/authentification/signin/decorations.dart';
import 'package:firebasedemo/screens/authentification/signin/email_verif.dart';
import 'package:firebasedemo/screens/authentification/signin/signin.dart';
import 'package:firebasedemo/screens/home/home_screen.dart';
/*
import 'package:firebase_ui_oauth_twitter/firebase_ui_oauth_twitter.dart';
*/
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


import '../../../firebase_options.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_storage/firebase_ui_storage.dart';


enum DesignLib {
  material(Icons.android),
  cupertino(Icons.apple);

  final IconData icon;
  const DesignLib(this.icon);
}

final designLib = ValueNotifier(DesignLib.material);
final brightness = ValueNotifier(Brightness.light);



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    emailLinkProviderConfig,
    PhoneAuthProvider(),
    GoogleProvider(clientId: GOOGLE_CLIENT_ID),
    /*AppleProvider(),
    FacebookProvider(clientId: FACEBOOK_CLIENT_ID),
    TwitterProvider(.
      apiKey: TWITTER_API_KEY,
      apiSecretKey: TWITTER_API_SECRET_KEY,
      redirectUri: TWITTER_REDIRECT_URI,
    ),*/
  ]);

  final storage = FirebaseStorage.instance;
/*
  final config = FirebaseUIStorageConfiguration(storage: storage);
*/

/*
  await FirebaseUIStorage.configure(config);
*/

  runApp(
    MyApp()
  );
  
  
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {



  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
      padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );


    return MaterialApp(
        theme: ThemeData(
        brightness: Brightness.light,
        visualDensity: VisualDensity.standard,
        inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),

    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle),
    textButtonTheme: TextButtonThemeData(style: buttonStyle),
    outlinedButtonTheme: OutlinedButtonThemeData(style: buttonStyle),
    ),
      home:
      StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          /*if (snapshot.hasData) {
            return HomeScreen();
          } else {
            return SignInScreen();
          }*/
          switch (snapshot.connectionState) {




            case ConnectionState.active:
              print('active');
              User? user = snapshot.data;
              if (user != null) {
                return HomeScreen();
              }
              else if (user != null && user.emailVerified){
                return EmailCheck();

              }
              else {
                return SignInScreen();
              }
              break;
            default:
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
              break;
          }
        },
      ),




    );
  }
}

