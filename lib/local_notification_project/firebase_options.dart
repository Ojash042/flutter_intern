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
    apiKey: 'AIzaSyCUCfYAtXwjkQZZ95A6-9PltoISjl_av7E',
    appId: '1:271563123010:web:45b9cc76ad5078ef7480db',
    messagingSenderId: '271563123010',
    projectId: 'notificationproject-adae6',
    authDomain: 'notificationproject-adae6.firebaseapp.com',
    storageBucket: 'notificationproject-adae6.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAOT-TQodcRDah-jmfCnf1eZqGiwLe2HTw',
    appId: '1:271563123010:android:df73c0c1f67cf9837480db',
    messagingSenderId: '271563123010',
    projectId: 'notificationproject-adae6',
    storageBucket: 'notificationproject-adae6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAsmiVzF7O2f7c3r2c-uxwW5uj-SYXLuB0',
    appId: '1:271563123010:ios:c1d04f9a097f9feb7480db',
    messagingSenderId: '271563123010',
    projectId: 'notificationproject-adae6',
    storageBucket: 'notificationproject-adae6.appspot.com',
    iosBundleId: 'com.example.ntfyApplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAsmiVzF7O2f7c3r2c-uxwW5uj-SYXLuB0',
    appId: '1:271563123010:ios:c1d04f9a097f9feb7480db',
    messagingSenderId: '271563123010',
    projectId: 'notificationproject-adae6',
    storageBucket: 'notificationproject-adae6.appspot.com',
    iosBundleId: 'com.example.ntfyApplication',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCUCfYAtXwjkQZZ95A6-9PltoISjl_av7E',
    appId: '1:271563123010:web:baa6840c26ebfb047480db',
    messagingSenderId: '271563123010',
    projectId: 'notificationproject-adae6',
    authDomain: 'notificationproject-adae6.firebaseapp.com',
    storageBucket: 'notificationproject-adae6.appspot.com',
  );

}