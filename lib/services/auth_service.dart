import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebasedemo/services/firestore_service.dart';

import '../firebase_options.dart';


class AuthService {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // signin with email and password
  static Future<void> signInWithEmailAndPassword(String email, String password) async {
    // get instance of FirebaseAuth
    FirebaseAuth auth = FirebaseAuth.instance;
    // signin with email and password and return user and send email verification
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // throw exception if error
      throw Exception(e.message);
    }
  }

  // signup with email and password and send email verification
  static Future<void> signUpWithEmailAndPassword(String email, String password, String role) async {
    // get instance of FirebaseAuth
    FirebaseAuth auth = FirebaseAuth.instance;
    // signup with email and password and send email verification
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      // send email verification
      await auth.currentUser!.sendEmailVerification();
      await FirestoreService().createRole(role);

      // save role on firestore users/userId


    } on FirebaseAuthException catch (e) {
      // throw exception if error
      throw Exception(e.message);
    }
  }

  // signout
  static Future<void> signOut() async {
    // get instance of FirebaseAuth
    FirebaseAuth auth = FirebaseAuth.instance;
    // signout
    await auth.signOut();
  }

  // reset password
  static Future<void> resetPassword(String email) async {
    // get instance of FirebaseAuth
    FirebaseAuth auth = FirebaseAuth.instance;
    // send password reset email
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      // throw exception if error
      throw Exception(e.message);
    }
  }

}