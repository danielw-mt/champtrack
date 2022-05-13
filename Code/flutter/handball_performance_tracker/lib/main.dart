import 'package:flutter/material.dart';
import 'screens/mainScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,).then((value)async  {
    // check internet connectivity
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        // pull from firebase to synchronize
        FirebaseFirestore db = FirebaseFirestore.instance;
      }
    } on SocketException catch (_) {
      print('not connected');
    }
    // start app
    runApp(MaterialApp(
        title: 'Handball Performance Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: mainScreen()));
  }).timeout(const Duration (seconds:5),onTimeout : onTimeout());

}

onTimeout() {
  runApp(MaterialApp(title: "Timeout"));
}

