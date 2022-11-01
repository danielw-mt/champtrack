import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/controllers/temp_controller.dart';
import 'package:handball_performance_tracker/old-widgets/start_game_screen/start_game_form.dart';
import 'package:handball_performance_tracker/old-constants/stringsGeneral.dart';
import '../old-widgets/nav_drawer.dart';

/// Screen that allows input of game properties
/// and is the beginning of a guided walkthrough for adjusting settings and selecting players before starting the game
class StartGameScreen extends StatefulWidget {
  StartGameScreen({Key? key}) : super(key: key);

  @override
  State<StartGameScreen> createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // after a hot reload the app crashes. This prevents it
    if (!Get.isRegistered<TempController>())
      return SafeArea(
          child: Column(
        children: [
          Text(StringsGeneral.lHotReloadError),
          ElevatedButton(
              onPressed: () {
                Get.toNamed("Dashboard");
              },
              child: Text("Home"))
        ],
      ));
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      drawer: NavDrawer(),
      body: StartGameForm(_scaffoldKey),
    ));
  }
}
