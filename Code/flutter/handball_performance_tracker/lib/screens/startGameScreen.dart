import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/controllers/tempController.dart';
import 'package:handball_performance_tracker/screens/dashboard.dart';
import 'package:handball_performance_tracker/widgets/start_game_screen/start_game_form.dart';
import 'package:handball_performance_tracker/constants/stringsDashboard.dart';
import 'package:handball_performance_tracker/constants/stringsGeneral.dart';
import '../widgets/nav_drawer.dart';

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
            key: _scaffoldKey,
            drawer: NavDrawer(),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container for menu button on top left corner
                MenuButton(_scaffoldKey),
                buildStartScreenContent(),
                buildBackButton()
              ],
            )));
  }

  /// Depending on what page of the screen you are render different main content
  Widget buildStartScreenContent() {
    return StartGameForm();
  }

  // Button back to Dashboard, button leading to the next form is the submit-button of the StartGameForm
  Widget buildBackButton() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      // 'Back' button
      ElevatedButton(
          onPressed: () {
            Get.to(() => Dashboard());
          },
          child: Text(StringsDashboard.lDashboard))
    ]);
  }
}
