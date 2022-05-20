import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'screens/mainScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'config/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // start app
  runApp(GetMaterialApp(
      title: 'Handball Performance Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      scrollBehavior:
          AppScrollBehavior(), // add scrollbehaviour so swiping is possible in web
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
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    // I am connected to a mobile network.
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.enableNetwork();
    print('connected');
    return "";
  } else {
    // TODO define behaviour for not connected i.e. wait 5 secs and try again
    print("not connected");
  }
}

onTimeout() {
  runApp(MaterialApp(title: "Timeout"));
}

// add scrollbehaviour so swiping is possible in web
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
