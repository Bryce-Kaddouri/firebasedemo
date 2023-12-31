// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBvBXRqYZDCnpBux7bzdBNebaRX2c2VW2o',
    appId: '1:1097205595439:web:252f61d2b092b89648f5da',
    messagingSenderId: '1097205595439',
    projectId: 'orderit-test-firebase',
    authDomain: 'orderit-test-firebase.firebaseapp.com',
    storageBucket: 'orderit-test-firebase.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBKq7k0i6TM6R77R6kYEek0G7xk_X9uwKg',
    appId: '1:1097205595439:android:d84c629c4ffc8ed648f5da',
    messagingSenderId: '1097205595439',
    projectId: 'orderit-test-firebase',
    storageBucket: 'orderit-test-firebase.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBoxbChpowvhIvgpnikHMo7owNUi9LHhYQ',
    appId: '1:1097205595439:ios:911ebb79ed74df4f48f5da',
    messagingSenderId: '1097205595439',
    projectId: 'orderit-test-firebase',
    storageBucket: 'orderit-test-firebase.appspot.com',
    iosClientId: '1097205595439-uaa5hsbbgl6dent2uglsat797t30bc5t.apps.googleusercontent.com',
    iosBundleId: 'com.example.firebasedemo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBoxbChpowvhIvgpnikHMo7owNUi9LHhYQ',
    appId: '1:1097205595439:ios:41dbf8d76f870f4e48f5da',
    messagingSenderId: '1097205595439',
    projectId: 'orderit-test-firebase',
    storageBucket: 'orderit-test-firebase.appspot.com',
    iosClientId: '1097205595439-8im5rmobketvle4bof4avkc41tpo9e1f.apps.googleusercontent.com',
    iosBundleId: 'com.example.firebasedemo.RunnerTests',
  );
}
