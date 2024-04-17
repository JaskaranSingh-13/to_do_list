// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyB7U9_F7Y9Rr9b4GEIC1bfYiM-myW9ygGo',
    appId: '1:741798507940:web:378d64732df87da7813d31',
    messagingSenderId: '741798507940',
    projectId: 'to-do-list-be4ca',
    authDomain: 'to-do-list-be4ca.firebaseapp.com',
    storageBucket: 'to-do-list-be4ca.appspot.com',
    measurementId: 'G-T9MHZ6544V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUdOjzkvmo-BUOfMBs5Il4QBfPEQvJS4U',
    appId: '1:741798507940:android:1dc8731e7881be05813d31',
    messagingSenderId: '741798507940',
    projectId: 'to-do-list-be4ca',
    storageBucket: 'to-do-list-be4ca.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBGRD1S44K-FsBU3dvXBrFE3jdPs7XAgSk',
    appId: '1:741798507940:ios:4b2393a22abdffc4813d31',
    messagingSenderId: '741798507940',
    projectId: 'to-do-list-be4ca',
    storageBucket: 'to-do-list-be4ca.appspot.com',
    iosBundleId: 'com.example.toDoList',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBGRD1S44K-FsBU3dvXBrFE3jdPs7XAgSk',
    appId: '1:741798507940:ios:4b2393a22abdffc4813d31',
    messagingSenderId: '741798507940',
    projectId: 'to-do-list-be4ca',
    storageBucket: 'to-do-list-be4ca.appspot.com',
    iosBundleId: 'com.example.toDoList',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB7U9_F7Y9Rr9b4GEIC1bfYiM-myW9ygGo',
    appId: '1:741798507940:web:1c36cc7efef64c31813d31',
    messagingSenderId: '741798507940',
    projectId: 'to-do-list-be4ca',
    authDomain: 'to-do-list-be4ca.firebaseapp.com',
    storageBucket: 'to-do-list-be4ca.appspot.com',
    measurementId: 'G-QDN0HPPNPR',
  );

}