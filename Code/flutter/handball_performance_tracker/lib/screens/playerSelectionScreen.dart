import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/controllers/tempController.dart';
import 'package:handball_performance_tracker/screens/startGameScreen.dart';
import 'package:handball_performance_tracker/utils/gameControl.dart';
import 'package:handball_performance_tracker/constants/stringsGeneral.dart';
import 'package:handball_performance_tracker/constants/stringsGameSettings.dart';
import 'package:handball_performance_tracker/widgets/helper_screen/alert_message_widget.dart';
import 'package:handball_performance_tracker/widgets/main_screen/ef_score_bar.dart';
import 'package:handball_performance_tracker/widgets/team_settings_screen/players_list.dart';
import '../widgets/nav_drawer.dart';
import '../screens/mainScreen.dart';

/// Screen that is displayed after startGameScreen and allows to select, add, and remove players before starting the game
class PlayerSelectionScreen extends StatefulWidget {
  PlayerSelectionScreen({Key? key}) : super(key: key);

  @override
  State<PlayerSelectionScreen> createState() => _PlayerSelectionScreenState();
}

class _PlayerSelectionScreenState extends State<PlayerSelectionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int startGameFlowStep = 0;

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
                buildBackNextButtons()
              ],
            )));
  }

  /// Depending on what page of the screen you are render different main content
  Widget buildStartScreenContent() {
    return PlayersList();
  }

  /// Buttons that allow to go to the next and last page in the flow
  Widget buildBackNextButtons() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      // 'Back' button
      ElevatedButton(
        onPressed: () {
          Get.to(() => StartGameScreen());
        },
        child: Text(StringsGeneral.lBack),
      ),
      // 'Next' button
      ElevatedButton(
          onPressed: () {
            // validate whether 7 players were selected on this page
            TempController tempController = Get.find<TempController>();
            // display alert if less than 7 have been selected
            if (tempController.getOnFieldPlayers().length != 7) {

              showDialog(
                  context: context,
                  builder: (BuildContext bcontext) {
                    return AlertDialog(
                        scrollable: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(menuRadius),
                        ),
                        content: CustomAlertMessageWidget(
                            StringsGameSettings.lStartGameAlertHeader +
                                "!\n" +
                                StringsGameSettings.lStartGameAlert));
                  });
            } else {
              tempController.updateOnFieldPlayers();
              tempController.setPlayerBarPlayers();
              startGame(context, preconfigured: true);
              Get.to(() => MainScreen());
              return;
            }
          },
          child: Text(StringsGeneral.lStartGameButton))
    ]);
  }
}
