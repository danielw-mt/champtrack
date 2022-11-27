import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/old-utils/icons.dart';
import 'package:handball_performance_tracker/old-utils/player_helper.dart';
import 'package:handball_performance_tracker/core/constants/design_constants.dart';
import '../../../../old-widgets/main_screen/seven_meter_menu.dart';
import 'package:handball_performance_tracker/core/constants/strings_general.dart';
import 'dart:math';
import 'package:handball_performance_tracker/data/models/models.dart';


void callSevenMeterPlayerMenu(context) {
  logger.d("Calling seven meter player menu");
  PageController pageController = PageController();
  showDialog(
      context: context,
      builder: (BuildContext bcontext) {
        return AlertDialog(
          scrollable: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(menuRadius),
          ),
          // alert contains a list of DialogButton objects
          content:
              // Column of "Player", horizontal line and Button-Row
              Column(
            children: [
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
                    child: Text(
                      StringsGeneral.lChooseSevenMeterPlayer,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Colors.purple,
                        fontSize: 20,
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
              Scrollbar(
                controller: pageController,
                thumbVisibility: true,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: PageView(
                    controller: pageController,
                    children: buildPageViewChildren(bcontext),
                  ),
                ),
              )
            ],
          ),
        );
      });
}

// a method for building the children of the pageview with players on field on the first page and all others on the next.
List<Widget> buildPageViewChildren(BuildContext context) {
  final TempController tempController = Get.find<TempController>();
  List<DialogButton> onFieldButtons = buildDialogButtonList(context);
  List<DialogButton> notOnFieldButtons = buildDialogButtonNotOnFieldList(context);

  // Build content for on field player page
  List<Widget> onFieldDisplay = [];
  for (int i = 0; i < tempController.getOnFieldPlayers().length - 1; i++) {
    onFieldDisplay.add(Column(
      children: [onFieldButtons[i], onFieldButtons[i + 1]],
    ));
    i++;
  }
  // If number of player uneven, add the last which is not inside a row.
  if (tempController.getOnFieldPlayers().length % 2 != 0) {
    onFieldDisplay.add(onFieldButtons[tempController.getOnFieldPlayers().length - 1]);
  }

  // Build content for not on field player page
  List<Widget> notOnFieldDisplay = [];
  for (int i = 0; i < notOnFieldButtons.length - 1; i++) {
    notOnFieldDisplay.add(Flexible(
      child: Column(
        children: [notOnFieldButtons[i], notOnFieldButtons[i + 1]],
      ),
    ));
    i++;
  }
  // If number of player uneven, add the last which is not inside a row.
  if (notOnFieldButtons.length % 2 != 0) {
    notOnFieldDisplay.add(Flexible(child: notOnFieldButtons[notOnFieldButtons.length - 1]));
  }
  return [
    Row(children: onFieldDisplay),
    Row(children: notOnFieldDisplay),
  ];
}

/// builds a list of Dialog buttons with players which are not on field
List<DialogButton> buildDialogButtonNotOnFieldList(BuildContext context) {
  final TempController tempController = Get.find<TempController>();
  List<DialogButton> dialogButtons = [];
  for (int i = 0; i < tempController.getSelectedTeam().players.length; i++) {
    if (tempController.getSelectedTeam().onFieldPlayers.contains(tempController.getSelectedTeam().players[i]) == false) {
      DialogButton dialogButton = buildDialogButton(context, tempController.getSelectedTeam().players[i], true);
      dialogButtons.add(dialogButton);
    }
  }
  return dialogButtons;
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
DialogButton buildDialogButton(BuildContext context, Player associatedPlayer, [isNotOnField]) {
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
      ? Text(
          buttonText,
          overflow: TextOverflow.ellipsis,
        )
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
                    size: (isNotOnField == null || getNotOnFieldIndex().length <= 7)
                        ? (width * 0.11)
                        : (width * 0.11 / getNotOnFieldIndex().length * 7),
                  ),
                ),
              ],
            ),
            // ButtonName
            Text(
              buttonText,
              style: TextStyle(
                color: Colors.black,
                overflow: TextOverflow.ellipsis,
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

    tempController.setPreviousClickedPlayer(tempController.getPlayerFromSelectedTeam(associatedPlayer.id!));
    // Check if associated player or lastClickedPlayer are notOnFieldPlayer. If yes, player menu appears to change the player.
    if (!tempController.getOnFieldPlayers().contains(associatedPlayer)) {
      tempController.addPlayerToChange(associatedPlayer);
    }
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
      color: lastClickedPlayerId == associatedPlayer.id ? Colors.purple : Color.fromARGB(255, 180, 211, 236),
      onPressed: () {
        logPlayerSelection();
        Navigator.pop(context);
        callSevenMeterMenu(context, true);
      });
}
