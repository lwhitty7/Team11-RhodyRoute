import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBfNelHY1aVIhL9tcvLf0e99XuphH88er4",
            authDomain: "rhody-route.firebaseapp.com",
            projectId: "rhody-route",
            storageBucket: "rhody-route.firebasestorage.app",
            messagingSenderId: "692599465029",
            appId: "1:692599465029:web:78495a49bc5ed4a0032f2c",
            measurementId: "G-RM69DXJ1F0"));
  } else {
    await Firebase.initializeApp();
  }
}
