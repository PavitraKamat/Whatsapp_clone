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
    apiKey: 'AIzaSyA_Y5-ecZCwCRDY8MCoGxvvXcp1RXzelcA',
    appId: '1:183806004172:web:3f9807a5beccbc5cd1ab69',
    messagingSenderId: '183806004172',
    projectId: 'whatsappclone-75ae7',
    authDomain: 'whatsappclone-75ae7.firebaseapp.com',
    storageBucket: 'whatsappclone-75ae7.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCmHey75_6ijWDOraoZpV0L_F96l0t4yFQ',
    appId: '1:183806004172:android:754f51fb1db34b23d1ab69',
    messagingSenderId: '183806004172',
    projectId: 'whatsappclone-75ae7',
    storageBucket: 'whatsappclone-75ae7.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCaDjyAupIAkjomPvqvVaMjAQYBlwnyoI4',
    appId: '1:183806004172:ios:a4a3992d9b035fdcd1ab69',
    messagingSenderId: '183806004172',
    projectId: 'whatsappclone-75ae7',
    storageBucket: 'whatsappclone-75ae7.firebasestorage.app',
    iosClientId: '183806004172-7p6dk3ij4hrkalgne9nnpapgka0l1pjl.apps.googleusercontent.com',
    iosBundleId: 'com.example.wtspClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCaDjyAupIAkjomPvqvVaMjAQYBlwnyoI4',
    appId: '1:183806004172:ios:a4a3992d9b035fdcd1ab69',
    messagingSenderId: '183806004172',
    projectId: 'whatsappclone-75ae7',
    storageBucket: 'whatsappclone-75ae7.firebasestorage.app',
    iosClientId: '183806004172-7p6dk3ij4hrkalgne9nnpapgka0l1pjl.apps.googleusercontent.com',
    iosBundleId: 'com.example.wtspClone',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA_Y5-ecZCwCRDY8MCoGxvvXcp1RXzelcA',
    appId: '1:183806004172:web:43fc265bed81f301d1ab69',
    messagingSenderId: '183806004172',
    projectId: 'whatsappclone-75ae7',
    authDomain: 'whatsappclone-75ae7.firebaseapp.com',
    storageBucket: 'whatsappclone-75ae7.firebasestorage.app',
  );

}