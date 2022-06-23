import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/screens/authenticationScreen.dart';
import 'package:handball_performance_tracker/screens/dashboard.dart';
import 'package:handball_performance_tracker/screens/settingsScreen.dart';
import 'package:handball_performance_tracker/screens/startGameScreen.dart';
import 'screens/mainScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'strings.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // start app
  runApp(GetMaterialApp(
      title: Strings.lAppTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      scrollBehavior:
          AppScrollBehavior(), // add scrollbehaviour so swiping is possible in web
      getPages: [
        GetPage(name: '/StartGameScreen', page: () => StartGameScreen()),
        GetPage(name: '/SettingsScreen', page: () => SettingsScreen()),
        GetPage(name: '/Dashboard', page: () => Dashboard()),
      ],
      home: FutureBuilder<dynamic>(
        future: _startupCheck(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            return StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("There was a problem with authentication"),
                    );
                  } else if (snapshot.hasData) {
                    // if we have a User object we are logged in and can display the app
                    return Dashboard();
                  } else {
                    return AuthenticationScreen(context: context);
                  }
                });
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(Strings.lError + ': ${snapshot.error}'),
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
                child: Text(Strings.lConnectionCheck),
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
    print(Strings.lConnected);
    return "";
  } else {
    // TODO define behaviour for not connected i.e. wait 5 secs and try again
    print(Strings.lNot + ' ' + Strings.lConnected);
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
