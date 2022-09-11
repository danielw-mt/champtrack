import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/screens/authenticationScreen.dart';
import 'package:handball_performance_tracker/screens/dashboard.dart';
import 'package:handball_performance_tracker/screens/startGameScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:handball_performance_tracker/widgets/authentication_screen/alert_widget.dart';
import 'config/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'constants/stringsGeneral.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // start app
  runApp(GetMaterialApp(
    title: StringsGeneral.lAppTitle,
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    scrollBehavior:
        AppScrollBehavior(), // add scrollbehaviour so swiping is possible in web
    initialRoute: '/',
    getPages: [
      GetPage(name: '/', page: () => Home()),
      GetPage(name: '/StartGameScreen', page: () => StartGameScreen()),
      GetPage(name: '/Dashboard', page: () => Dashboard()),
    ],
  ));
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
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
                  return AuthenticationScreen();
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
              child: Text(StringsGeneral.lError + ': ${snapshot.error}'),
            )
          ];
        } else {
          children = <Widget>[
            CustomAlertWidget("Suche Verbindung..."),
          ];
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }
}

Future<dynamic> _startupCheck() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kIsWeb) {
    // when the app is run in web, also initialize dev database
    // this feature is however not supported for other platforms
    if (Firebase.apps.length < 2) {
      // only initialize for the first time and not on hot reload
      await Firebase.initializeApp(
          name: "dev", options: DevFirebaseOptions.currentPlatform);
    }
  }
  // if connected force synchronization
  var connectivityResult = await (Connectivity().checkConnectivity());
  // if (connectivityResult == ConnectivityResult.mobile ||
  //     connectivityResult == ConnectivityResult.wifi) {
  //   // I am connected to a mobile network.
  //   FirebaseFirestore db = FirebaseFirestore.instance;
  //   db.enableNetwork();
  //   print(StringsGeneral.lConnected);
  // } else {
  //   // TODO define behaviour for not connected i.e. wait 5 secs and try again
  //   print(StringsGeneral.lNot + ' ' + StringsGeneral.lConnected);

  // }
  FirebaseFirestore db = FirebaseFirestore.instance;
  db.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  // TODO if platform is web implement this line
  // await db.enablePersistence(const PersistenceSettings(synchronizeTabs: true));
  return "";
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
