import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA8cJRNJIHkQbV5fi7uORLjVieebRe0ufw',
    appId: '1:923655831668:web:41c5fb71223d7421eb9121',
    messagingSenderId: '923655831668',
    projectId: 'flutter-fundamentals-demo',
    authDomain: 'flutter-fundamentals-demo.firebaseapp.com',
    storageBucket: 'flutter-fundamentals-demo.firebasestorage.app',
    measurementId: 'G-XC0K7ECQ4Q',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8cJRNJIHkQbV5fi7uORLjVieebRe0ufw',
    appId: '1:923655831668:android:41c5fb71223d7421eb9121',
    messagingSenderId: '923655831668',
    projectId: 'flutter-fundamentals-demo',
    storageBucket: 'flutter-fundamentals-demo.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA8cJRNJIHkQbV5fi7uORLjVieebRe0ufw',
    appId: '1:923655831668:ios:41c5fb71223d7421eb9121',
    messagingSenderId: '923655831668',
    projectId: 'flutter-fundamentals-demo',
    storageBucket: 'flutter-fundamentals-demo.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA8cJRNJIHkQbV5fi7uORLjVieebRe0ufw',
    appId: '1:923655831668:ios:41c5fb71223d7421eb9121',
    messagingSenderId: '923655831668',
    projectId: 'flutter-fundamentals-demo',
    storageBucket: 'flutter-fundamentals-demo.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA8cJRNJIHkQbV5fi7uORLjVieebRe0ufw',
    appId: '1:923655831668:web:41c5fb71223d7421eb9121',
    messagingSenderId: '923655831668',
    projectId: 'flutter-fundamentals-demo',
    storageBucket: 'flutter-fundamentals-demo.firebasestorage.app',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyA8cJRNJIHkQbV5fi7uORLjVieebRe0ufw',
    appId: '1:923655831668:web:41c5fb71223d7421eb9121',
    messagingSenderId: '923655831668',
    projectId: 'flutter-fundamentals-demo',
    storageBucket: 'flutter-fundamentals-demo.firebasestorage.app',
  );

  static FirebaseOptions get currentPlatform {
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
        return linux;
      default:
        return web;
    }
  }
}
