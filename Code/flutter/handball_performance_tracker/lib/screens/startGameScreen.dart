import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/controllers/tempController.dart';
import 'package:handball_performance_tracker/screens/dashboard.dart';
import 'package:handball_performance_tracker/utils/gameControl.dart';
import 'package:handball_performance_tracker/widgets/start_game_screen/player_positioning.dart';
import 'package:handball_performance_tracker/widgets/start_game_screen/start_game_form.dart';
import 'package:handball_performance_tracker/constants/stringsDashboard.dart';
import 'package:handball_performance_tracker/constants/stringsGeneral.dart';
import 'package:handball_performance_tracker/constants/stringsGameSettings.dart';
import 'package:handball_performance_tracker/widgets/team_settings_screen/players_list.dart';
import '../widgets/nav_drawer.dart';
import '../widgets/settings_screen/game_start_stop_buttons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../screens/mainScreen.dart';

/// Screen that contains a guided walkthrough for adjusting settings and
/// selecting players before starting the game
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
    // after a hot reload the app crashes. This prevents it
    if (!Get.isRegistered<TempController>())
      return Column(
        children: [
          Text(StringsGeneral.lHotReloadError),
          ElevatedButton(
              onPressed: () {
                Get.toNamed("Dashboard");
              },
              child: Text("Home"))
        ],
      );
    return Scaffold(
        key: _scaffoldKey,
        drawer: NavDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container for menu button on top left corner
            MenuButton(_scaffoldKey),
            buildStartScreenContent(),
            buildBackNextButtons()
          ],
        ));
  }

  /// Depending on what page of the screen you are render different main content
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

  /// Buttons that allow to go to the next and last page in the flow
  /// pages are set from 0 to 3 in startGameFlowStep
  Widget buildBackNextButtons() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      // 'Back' button
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
        // when page 0 is reached change the text of the button
        child: startGameFlowStep == 0
            ? Text(StringsDashboard.lDashboard)
            : Text(StringsGeneral.lBack),
      ),
      // 'Next' button
      ElevatedButton(
          onPressed: () {
            // go to page 1
            if (startGameFlowStep == 0) {
              setState(() {
                print("page 0 or 2");
                startGameFlowStep = 1;
              });
              return;
            }
            // validate whether 7 players were selected on this page
            if (startGameFlowStep == 1) {
              TempController tempController = Get.find<TempController>();
              // display alert if less than 7 have been selected
              if (tempController.getOnFieldPlayers().length != 7) {
                Alert(
                        context: context,
                        title: StringsGameSettings.lStartGameAlertHeader,
                        type: AlertType.error,
                        desc: StringsGameSettings.lStartGameAlert)
                    .show();
              } else {
                setState(() {
                  startGameFlowStep = 2;
                });
                return;
              }
            }
            // go to page 3
            if (startGameFlowStep == 2) {
              setState(() {
                startGameFlowStep = 3;
              });
              return;
            }
            // start game from last page and go to mainscreen
            if (startGameFlowStep == 3) {
              startGame(context);
              Get.to(MainScreen());
              return;
            }
          },
          // when page 3 is reached change the text of the button
          child: startGameFlowStep == 3
              ? Text(StringsGameSettings.lStartGameButton)
              : Text(StringsGeneral.lNext))
    ]);
  }
}
