import 'package:flutter/material.dart';
import 'screens/mainScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'config/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:html' as html;
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // ).then((value) async {
  //   // check internet connectivity
  //   try {
  //     final result = await InternetAddress.lookup('www.google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       print('connected');
  //       // pull from firebase to synchronize
  //       FirebaseFirestore db = FirebaseFirestore.instance;
  //     }
  //   } on SocketException catch (_) {
  //     print('not connected');
  //   }
  // start app
  runApp(GetMaterialApp(
      title: 'Handball Performance Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder<dynamic>(
        future: _startupCheck(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            return MainScreen();
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Checking connection...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      )));
}

Future<dynamic> _startupCheck() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // if connected force synchronization
  try {
    // final result = await InternetAddress.lookup('example.com');
    final result = html.window.navigator.connection;

    if (result!.downlink! > 0) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      db.enableNetwork();
      print('connected');
      return "";
    }
  } on SocketException catch (_) {
    print('not connected');
  }
}

onTimeout() {
  runApp(MaterialApp(title: "Timeout"));
}
