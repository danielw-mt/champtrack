import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/controllers/globalController.dart';
import 'package:handball_performance_tracker/screens/dashboard.dart';
import 'package:handball_performance_tracker/utils/gameControl.dart';
import 'package:handball_performance_tracker/widgets/start_game_screen/player_positioning.dart';
import 'package:handball_performance_tracker/widgets/start_game_screen/start_game_form.dart';
import 'package:handball_performance_tracker/strings.dart';
import 'package:handball_performance_tracker/widgets/team_settings_screen/players_list.dart';
import '../widgets/nav_drawer.dart';
import '../widgets/settings_screen/game_start_stop_buttons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../screens/mainScreen.dart';

// TODO change this to Statefulwidget
// turn team selection screen into team selection screen and teamSelectionWidget
// build player position widget as a simple list
// build halbzeit seite auswählen widget
// dependign on the State of StartGameScreen build StartGameForm,teamSelectionDropdown, PlayersList, PlayerPositionWidget, halbzeit seite auswählen widget, check everything widget

class StartGameScreen extends StatefulWidget {
  StartGameScreen({Key? key}) : super(key: key);

  @override
  State<StartGameScreen> createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int startGameFlowStep = 0;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<GlobalController>())
      return Column(
        children: [
          Text(
              "There seems to be a problem. Please go back to the home screen"),
          ElevatedButton(
              onPressed: () {
                Get.toNamed("Dashboard");
              },
              child: Text("Home"))
        ],
      );
    print("Page $startGameFlowStep");
    return Scaffold(
        key: _scaffoldKey,
        drawer: NavDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container for menu button on top left corner
            MenuButton(_scaffoldKey),
            buildStartScreenContent(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              ElevatedButton(
                onPressed: () {
                  if (startGameFlowStep > 0) {
                    setState(() {
                      startGameFlowStep -= 1;
                    });
                  } else {
                    Get.to(Dashboard());
                  }
                },
                child: startGameFlowStep == 0
                    ? Text(Strings.lDashboard)
                    : Text(Strings.lBack),
              ),
              ElevatedButton(
                  onPressed: () {
                    // for first page and page 3 just go to next page normally
                    if (startGameFlowStep == 0) {
                      setState(() {
                        print("page 0 or 2");
                        startGameFlowStep = 1;
                      });
                      return;
                    }
                    if (startGameFlowStep == 1) {
                      GlobalController globalController =
                          Get.find<GlobalController>();
                      if (globalController
                              .selectedTeam.value.onFieldPlayers.length !=
                          7) {
                        Alert(
                                context: context,
                                title: Strings.lWarningPlayerNumberErrorMessage,
                                type: AlertType.error,
                                desc: Strings.lPlayerNumberErrorMessage)
                            .show();
                      } else {
                        print("page 1 and correct");
                        setState(() {
                          startGameFlowStep = 2;
                        });
                        return;
                      }
                    }
                    if (startGameFlowStep == 2) {
                      setState(() {
                        startGameFlowStep = 3;
                      });
                      return;
                    }
                    if (startGameFlowStep == 3) {
                      startGame(context);
                      Get.to(MainScreen());
                      return;
                    }
                  },
                  child: startGameFlowStep == 3
                      ? Text(Strings.lStartGameButton)
                      : Text(Strings.lNext))
            ])
          ],
        ));
  }

  Widget buildStartScreenContent() {
    if (startGameFlowStep == 0) {
      return StartGameForm();
    }
    if (startGameFlowStep == 1) {
      return PlayersList();
    }
    if (startGameFlowStep == 2) {
      return PlayerPositioning();
    }

    if (startGameFlowStep == 3) {
      // return
      return Text("Verifiy inputs");
    }
    return Container();
  }
}
