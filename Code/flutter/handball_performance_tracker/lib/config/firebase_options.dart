// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
// created during config. Do not touch this file
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAoprvB5-e1kupebLSzAKkPy4tF3-QzCng',
    appId: '1:910235672034:web:7b8f3be5f636eb3bbeedbb',
    messagingSenderId: '910235672034',
    projectId: 'handball-performance-tracker',
    authDomain: 'handball-performance-tracker.firebaseapp.com',
    storageBucket: 'handball-performance-tracker.appspot.com',
    measurementId: 'G-8YM5J1DHGX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBQFdpe1IL5Vrh5sAyAIWaY4isy0LdDUc8',
    appId: '1:910235672034:android:9f6e014a8d7d1b4bbeedbb',
    messagingSenderId: '910235672034',
    projectId: 'handball-performance-tracker',
    storageBucket: 'handball-performance-tracker.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBaokiMdJKekw0hT1AYwPZ-QoLOhiLpgAw',
    appId: '1:910235672034:ios:3d33781e9d42829dbeedbb',
    messagingSenderId: '910235672034',
    projectId: 'handball-performance-tracker',
    storageBucket: 'handball-performance-tracker.appspot.com',
    iosClientId: '910235672034-pnm1ks4onkhtst3h6st5n5cjep5o53di.apps.googleusercontent.com',
    iosBundleId: 'mad.tf.fau.de.handballPerformanceTracker',
  );
}

class DevFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'DevFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DevFirebaseOptions have not been configured for iOS - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DevFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DevFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DevFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DevFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDV7n7FmKrrNeLLiJ02nXGs8pIMLtjzHFs',
    appId: '1:974814103289:web:851ef360793cebd006c428',
    messagingSenderId: '910235672034',
    projectId: 'handball-tracker-dev',
    authDomain: 'handball-tracker-dev.appspot.com',
    storageBucket: 'handball-performance-tracker.appspot.com',
    measurementId: 'G-0BMS52683E',
  );

  /*static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBQFdpe1IL5Vrh5sAyAIWaY4isy0LdDUc8',
    appId: '1:910235672034:android:9f6e014a8d7d1b4bbeedbb',
    messagingSenderId: '910235672034',
    projectId: 'handball-tracker-dev',
    //storageBucket: 'handball-performance-tracker.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBaokiMdJKekw0hT1AYwPZ-QoLOhiLpgAw',
    appId: '1:910235672034:ios:3d33781e9d42829dbeedbb',
    messagingSenderId: '910235672034',
    projectId: 'handball-tracker-dev',
    //storageBucket: 'handball-performance-tracker.appspot.com',
    //iosClientId: '910235672034-pnm1ks4onkhtst3h6st5n5cjep5o53di.apps.googleusercontent.com',
    //iosBundleId: 'mad.tf.fau.de.handballPerformanceTracker',
  );*/
}

