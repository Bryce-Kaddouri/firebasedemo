// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart'
    hide PhoneAuthProvider, EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebasedemo/screens/authentification/check_email/check_email.dart';


import 'package:firebasedemo/screens/authentification/signin/signin.dart';
import 'package:firebasedemo/screens/home/admin_screen.dart';
import 'package:firebasedemo/screens/home/home_screen.dart';
import 'package:firebasedemo/services/firestore_service.dart';
import 'package:flutter/material.dart';


import '../../../firebase_options.dart';



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
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              print('active');
              User? user = snapshot.data;
              if (user != null) {
                if(user.emailVerified == false){
                  return CheckEmailScreen();
                }
                else{

                  return FutureBuilder(
                    future: FirestoreService().getRole(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        if(snapshot.data == 'admin'){
                          return AdminScreen();
                        }else if (snapshot.data == 'user'){
                          return HomeScreen();
                        }
                        else{
                          return const Scaffold(
                            body: Center(
                              child: Text('Error'),
                            ),
                          );
                        }
                      }
                      else{
                        return const Scaffold(
                          body: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  );
/*
                  return HomeScreen();
*/
                }
              }
              else {
                return SigninScreen();
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

