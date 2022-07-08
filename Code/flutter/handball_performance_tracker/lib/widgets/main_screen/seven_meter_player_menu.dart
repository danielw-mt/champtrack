import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/utils/icons.dart';
import 'package:handball_performance_tracker/widgets/main_screen/seven_meter_menu.dart';
import 'package:handball_performance_tracker/controllers/persistentController.dart';
import '../../constants/stringsGeneral.dart';
import '../../controllers/tempController.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';
import '../../data/game_action.dart';
import '../../data/player.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: false // Should each log print contain a timestamp
      ),
);

void callSevenMeterPlayerMenu(context) {
  logger.d("Calling seven meter player menu");
  final TempController tempController = Get.find<TempController>();
  List<DialogButton> dialogButtons = buildDialogButtonList(context);
  Alert(
    style: AlertStyle(
      // make round edges
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      // false so there is no big close-Button at the bottom
      isButtonVisible: false,
    ),
    context: context,
    // alert contains a list of DialogButton objects
    content:
        // Column of "Spieler", horizontal line and Button-Row
        Column(
      children: [
        // upper row: "Spieler" Text on left and "Assist" will pop up on right after a goal.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                StringsGeneral.lPlayer,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              // Change from "" to "Assist" after a goal.
              child: Obx(
                () => Text(
                  tempController.getPlayerMenuText(),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.purple,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        // horizontal line
        const Divider(
          thickness: 2,
          color: Colors.black,
          height: 6,
        ),
        // Button-Row: one Row with four Columns of one or two buttons

        tempController.getOnFieldPlayers().length == 7
            ? Row(children: [
                dialogButtons[0],
                Column(
                  children: [dialogButtons[1], dialogButtons[2]],
                ),
                Column(
                  children: [dialogButtons[3], dialogButtons[4]],
                ),
                Column(
                  children: [dialogButtons[5], dialogButtons[6]],
                ),
              ])
            : Text("7 Players were not selected. Cannot display this Menu!"),
      ],
    ),
  ).show();
}

/// builds a list of Dialog buttons
List<DialogButton> buildDialogButtonList(BuildContext context) {
  final TempController tempController = Get.find<TempController>();
  List<DialogButton> dialogButtons = [];
  for (Player player in tempController.getOnFieldPlayers()) {
    DialogButton dialogButton = buildDialogButton(context, player);
    dialogButtons.add(dialogButton);
  }
  return dialogButtons;
}

/// builds a single dialog button that logs its text (=player name) to firestore
/// and updates the game state
DialogButton buildDialogButton(BuildContext context, Player associatedPlayer) {
  PersistentController persistentController = Get.find<PersistentController>();
  TempController tempController = Get.find<TempController>();

  GameAction lastAction = persistentController.getLastAction();
  String? lastClickedPlayerId = lastAction.playerId;
  print("lastclicked player: $lastClickedPlayerId");
  print("associated player id ${associatedPlayer.id}");

  String buttonText = associatedPlayer.lastName;
  if (associatedPlayer.id == lastClickedPlayerId) {
    buttonText = StringsGeneral.lSamePlayer;
  }

  String buttonNumber = (associatedPlayer.number).toString();
  final double width = MediaQuery.of(context).size.width;
  final double height = MediaQuery.of(context).size.height;
  Widget buttonWidget = associatedPlayer.id == lastClickedPlayerId
      ? Text(buttonText)
      : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // ButtonNumber
                Text(
                  buttonNumber,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: (width * 0.03),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Shirt
                Center(
                  child: Icon(
                    MyFlutterApp.t_shirt,
                    size: (width * 0.11),
                  ),
                ),
              ],
            ),
            // ButtonName
            Text(
              buttonText,
              style: TextStyle(
                color: Colors.black,
                fontSize: (width * 0.02),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );

  // Get width and height, so the sizes can be calculated relative to those. So it should look the same on different screen sizes.

  /// @return "" if action wasn't a goal, "solo" when player scored without
  /// assist and "assist" when player click was assist

  void logPlayerSelection() async {
    logger.d("Logging the player selection");

    tempController.setLastClickedPlayer(
        tempController.getPlayerFromSelectedTeam(associatedPlayer.id!));
  }

  return DialogButton(
      child: buttonWidget,
      // Column with 2 entries: 1. a Stack with Shirt & buttonNumber and 2. buttonText

      // have some space between the buttons
      margin: EdgeInsets.all(min(height, width) * 0.013),
      // have round edges with same degree as Alert dialog
      radius: const BorderRadius.all(Radius.circular(15)),
      // set height and width of buttons so the shirt and name are fitting inside
      height: width * 0.14,
      width: width * 0.14,
      color: lastClickedPlayerId == associatedPlayer.id
          ? Colors.purple
          : Color.fromARGB(255, 180, 211, 236),
      onPressed: () {
        logPlayerSelection();
        Navigator.pop(context);
        callSevenMeterMenu(context, true);
      });
}
