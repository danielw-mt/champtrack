import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/controllers/globalController.dart';
import 'package:handball_performance_tracker/data/player.dart';
import 'package:handball_performance_tracker/utils/fieldSizeParameter.dart'
    as fieldSizeParameter;
import 'dart:math';

// factor to get the height of a button + seperator line
double buttonHeightFactor = 1.26;
// height of a button -> The full height should be used when 7 buttons are displayed.
double buttonHeight = fieldSizeParameter.fieldHeight / (7 * buttonHeightFactor);
// height of button + line between buttons.
double lineAndButtonHeight = fieldSizeParameter.fieldHeight / 7;
// width of efscore bar
double scoreBarWidth = fieldSizeParameter.screenWidth * 0.12;
// track if plus button was pressed, so the adapted color of the pressed player on efscore bar does not change back to normal already.
bool plusPressed = false;

/*
* Class that builds the column with buttons for both permanent efscore bar and player changing popup.
* @param buttons: List of Container which will be pub into a ListView
* @return: Container with ListView which shows the entries of the input list.
*/
class ButtonBar extends StatelessWidget {
  List<Container> buttons = [];
  ButtonBar({required buttons}) {
    this.buttons = buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: scoreBarWidth,
      height: buttons.length * lineAndButtonHeight,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 224, 224, 224),
          // set border so edges can be made round
          border: Border.all(
            color: const Color.fromARGB(255, 224, 224, 224),
          ),
          // make round edges
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      // ListView which has all given Container-Buttons as entries
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return buttons[index];
        },
        // line between the buttons
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: buttons.length,
      ),
    );
  }
}

/*
* Class that builds the column with buttons for permanent efscore bar.
*/
class EfScoreBar extends StatelessWidget {
  const EfScoreBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalController globalController = Get.find<GlobalController>();

    List<Container> buttons = [];
    for (int i = 0; i < globalController.chosenPlayers.value.length; i++) {
      Container button = buildPlayerButton(context, i, true);
      buttons.add(button);
    }
    return ButtonBar(buttons: buttons);
  }
}

// Opens a popup menu besides the Efscorebar.
// @param buttons: Buttons to be displayed in popup
// @param i: index of button to adapt the vertical position so the popup opens besides the pressed button.
void showPopup(BuildContext context, List<Container> buttons, int i) {
  final GlobalController globalController = Get.find<GlobalController>();
  showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(

                // Make round borders.
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),

                // Set padding to all sides, so the popup has the needed size and position.
                insetPadding: EdgeInsets.only(
                    // The dialog should appear on the right side of Efscore bar, so the padding on the right side need to be == width of scorebar.
                    right: scoreBarWidth,
                    // As the dialog has also width = scoreBarWidth, the left side padding is whole screenWidth-2*scoreBarWidth
                    left: fieldSizeParameter.screenWidth - scoreBarWidth * 2,
                    // The dialog should open below the toolbar and other padding. Depending on the position (=index i) of the pressed button,
                    // the top padding changes, so the dialog opens more or less besides the pressed button.
                    top: fieldSizeParameter.toolbarHeight +
                        fieldSizeParameter.paddingTop +
                        max((i - (buttons.length / 2).round()), 0) *
                            lineAndButtonHeight,
                    // Bottom padding is determined similar to top padding.
                    bottom: fieldSizeParameter.paddingBottom +
                        max(((7 - i) - buttons.length), 0) *
                            lineAndButtonHeight),
                // Set contentPadding to zero so there is no white padding around the bar.
                contentPadding: EdgeInsets.zero,
                content: Builder(
                  builder: (context) {
                    plusPressed = false;
                    // show a ButtonBar inside the dialog with given buttons.
                    return ButtonBar(buttons: buttons);
                  },
                ));
          })
      // When closing check if Popup closes because the plus button was pressed (=> player is still selected on efscore bar)
      // or because of other reasons (chose a player for substitution or just pressed anywhere in screen => player is unselected)
      .then((_) => plusPressed
          ? null
          : globalController.playerToChange.value = Player());
}

/// builds a single button which represents a player
/// @param i: Index of player that is represented by the button.
///           If isPermanentBar, it's the entry of globalController.chosenPlayers.
///           Else, it's the entry of globalController.playersNotOnField.
/// @param isPermanentBar: true for building EfScoreBar which is permanently there with current players on field,
///                        false for showing possible substitue player
/// @return Container with TextButton representing the player.
///         If isPermanentBar, on pressing the button a new popup with possible substitute player pops up.
///         Else, the player which button was pressed in globalController.chosenPlayers is changed with player
///           with index i in globalController.playersNotOnField.
Container buildPlayerButton(BuildContext context, int i, bool isPermanentBar) {
  final GlobalController globalController = Get.find<GlobalController>();

  // Get player which have at least one of the given positions.
  List<Player> playerWithSamePosition(List<String> positions) {
    List<Player> substitutePlayer = [];

    // TODO : here go through the list with available players that are not on field
    for (Player player in globalController.playersNotOnField.value) {
      for (String position in positions) {
        if (player.positions.contains(position)) {
          substitutePlayer.add(player);
          break;
        }
      }
    }
    return substitutePlayer;
  }

  // Popup after clicking on one player at efscore bar.
  void popupSubstitutePlayer() {
    // Save pressed player, so this player can be changed in the next step.
    globalController.playerToChange.value =
        globalController.chosenPlayers.value[i];
    globalController.refresh();

    // Build buttons out of players that are not on field and have the same position as pressed player.
    List<Player> players = playerWithSamePosition(
        globalController.chosenPlayers.value[i].positions);
    List<Container> buttons = [];
    for (int k = 0; k < players.length; k++) {
      int l = globalController.playersNotOnField.indexOf(players[k]);
      Container button = buildPlayerButton(context, l, false);
      buttons.add(button);
    }
    // Add the button with the plus here.
    buttons.add(buildPlusButton(context));
    // Open popup dialog.
    showPopup(context, buttons, i);
  }

  // Changes player which was pressed in the efscore bar (globalController.playerToChange)
  // with a player which was pressed in a popup dialog.
  void changePlayer() {
    // get index of player which was pressed in efscore bar in globalController.chosenPlayers
    int k = globalController.chosenPlayers.value
        .indexOf(globalController.playerToChange.value);
    // Change the player which was pressed in efscore bar in globalController.chosenPlayers to the player which was pressed in popup dialog.
    globalController.chosenPlayers.value[k] =
        globalController.playersNotOnField.value[i];

    // Change the player which was pressed in popup dialog in globalController.playersNotOnField to the player which was pressed in efscore bar.
    globalController.playersNotOnField.value[i] =
        globalController.playerToChange.value;

    globalController.refresh();
  }

  return Container(
    height: buttonHeight,
    // Use Obx, so the button adapts to globalController values once they are changed.
    child: Obx(
      () => TextButton(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              isPermanentBar
                  ? globalController.chosenPlayers.value[i].lastName +
                      " #" +
                      (globalController.chosenPlayers.value[i].number)
                          .toString()
                  : globalController.playersNotOnField.value[i].lastName +
                      " #" +
                      (globalController.playersNotOnField.value[i].number)
                          .toString(),
              style: TextStyle(color: Colors.black, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            // TODO change to real efscore
            Text(
              "EFSCORE",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
        onPressed: () {
          if (isPermanentBar) {
            popupSubstitutePlayer();
          } else {
            changePlayer();
            Navigator.pop(context, true);
            globalController.playerToChange.value = Player();
          }
        },
        style: TextButton.styleFrom(
          // TODO Colorcoding by efscore
          // Color of pressed player changes on efscore bar.
          backgroundColor: isPermanentBar &&
                  globalController.playerToChange.value ==
                      globalController.chosenPlayers.value[i]
              ? Colors.blue
              : const Color.fromARGB(255, 180, 211, 236),
          // make round button edges
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    ),
  );
}

// Builds the plus button which is only present in popup.
Container buildPlusButton(BuildContext context) {
  final GlobalController globalController = Get.find<GlobalController>();
  // Popup after clicking on plus at popup dialog.
  // Shows all player which are not on field.
  void popupAllPlayer() {
    List<Container> buttons = [];
    for (int i = 0; i < globalController.playersNotOnField.value.length; i++) {
      Container button = buildPlayerButton(context, i, false);
      buttons.add(button);
    }
    showPopup(context, buttons, 0);
  }

  return Container(
    height: buttonHeight,
    child: TextButton(
      child: const Icon(
        Icons.add,
        color: Colors.black,
      ),
      onPressed: () {
        plusPressed = true;
        Navigator.pop(context);
        popupAllPlayer();
      },
      style: TextButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 180, 211, 236),
        // make round button edges
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    ),
  );
}
