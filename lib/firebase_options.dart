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
    apiKey: 'AIzaSyBe-VYcATmuXpdJDt_xGfpKzkQpb-C8AE8',
    appId: '1:996094710867:web:4637d5055ecfb56cc0a2a6',
    messagingSenderId: '996094710867',
    projectId: 'not-mynotes',
    authDomain: 'not-mynotes.firebaseapp.com',
    storageBucket: 'not-mynotes.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCqZEGgspViz5PrgWdE3LhfJIuw4wAolDo',
    appId: '1:996094710867:android:78ffcf0bbd37ac54c0a2a6',
    messagingSenderId: '996094710867',
    projectId: 'not-mynotes',
    storageBucket: 'not-mynotes.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA_zT2MUIReDuYopeQwY33MqAsG0E2whsc',
    appId: '1:996094710867:ios:2f6a0fd5f63b9a38c0a2a6',
    messagingSenderId: '996094710867',
    projectId: 'not-mynotes',
    storageBucket: 'not-mynotes.appspot.com',
    iosClientId: '996094710867-1014ttqpo5rthc80h2bulni1soevqfbt.apps.googleusercontent.com',
    iosBundleId: 'com.example.testingnote',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA_zT2MUIReDuYopeQwY33MqAsG0E2whsc',
    appId: '1:996094710867:ios:b3a9bc291a7d6cfbc0a2a6',
    messagingSenderId: '996094710867',
    projectId: 'not-mynotes',
    storageBucket: 'not-mynotes.appspot.com',
    iosClientId: '996094710867-9m28chdci62dkukfka1sun5tj2ginpr7.apps.googleusercontent.com',
    iosBundleId: 'com.example.testingnote.RunnerTests',
  );
}
