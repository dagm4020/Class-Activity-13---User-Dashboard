import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAA2r2KGKPKNJvQE75ZduWBMHqItChtgAY',
    appId: '1:894423350084:web:6e0c89e8e2115ce475f511',
    messagingSenderId: '894423350084',
    projectId: 'user-dashboard-761fb',
    authDomain: 'user-dashboard-761fb.firebaseapp.com',
    storageBucket: 'user-dashboard-761fb.firebasestorage.app',
    measurementId: 'G-4NPD5XYE5D',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBt5yULtAci8jk7i4ctGJatHwWFeYZEw84',
    appId: '1:894423350084:android:449911d9331ef04375f511',
    messagingSenderId: '894423350084',
    projectId: 'user-dashboard-761fb',
    storageBucket: 'user-dashboard-761fb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCTtKU7mEV50lginCMGSjJnhOWvcZtgeeY',
    appId: '1:894423350084:ios:ffc4382022e4006875f511',
    messagingSenderId: '894423350084',
    projectId: 'user-dashboard-761fb',
    storageBucket: 'user-dashboard-761fb.firebasestorage.app',
    iosBundleId: 'com.example.userDashboard',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCTtKU7mEV50lginCMGSjJnhOWvcZtgeeY',
    appId: '1:894423350084:ios:ffc4382022e4006875f511',
    messagingSenderId: '894423350084',
    projectId: 'user-dashboard-761fb',
    storageBucket: 'user-dashboard-761fb.firebasestorage.app',
    iosBundleId: 'com.example.userDashboard',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAA2r2KGKPKNJvQE75ZduWBMHqItChtgAY',
    appId: '1:894423350084:web:521749457348e51c75f511',
    messagingSenderId: '894423350084',
    projectId: 'user-dashboard-761fb',
    authDomain: 'user-dashboard-761fb.firebaseapp.com',
    storageBucket: 'user-dashboard-761fb.firebasestorage.app',
    measurementId: 'G-H4S3M0FVRY',
  );
}
