import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/data/player.dart';
import 'package:handball_performance_tracker/utils/fieldSizeParameter.dart'
    as fieldSizeParameter;
import 'package:handball_performance_tracker/utils/player_helper.dart';
import 'dart:math';
import 'package:rainbow_color/rainbow_color.dart';

import '../../controllers/tempController.dart';

// Radius of round edges
double menuRadius = 8.0;
double buttonRadius = 8.0;
// Width of padding between buttons
double paddingWidth = 8.0;
// height of button + line between buttons.
double lineAndButtonHeight = fieldSizeParameter.fieldHeight / 7;
// height of a button -> The full height should be used when 7 buttons are displayed.
double buttonHeight = (fieldSizeParameter.fieldHeight - paddingWidth * 5.5) / 7;
// width of popup
double popupWidth = buttonHeight + 3 * paddingWidth;
// width of efscore bar
double scorebarWidth = popupWidth * 2.3 - 2 * paddingWidth;
// width of a button in scorebar
double scorebarButtonWidth = scorebarWidth;
// track if plus button was pressed, so the adapted color of the pressed player on efscore bar does not change back to normal already.
bool plusPressed = false;
// Color of unpressed button
Color buttonColor = Color.fromARGB(255, 230, 230, 230);
// Color of pressed button
Color pressedButtonColor = Colors.blue;
double numberFontSize = 18;
double nameFontSize = 14;
// Spectrum for color coding of efscore
// TODO: Adapt the range to typical efscore values
var rb = Rainbow(spectrum: [
  Color(0xfffe7e6d),
  Color(0xfff8c4c0),
  Color(0xffeceef3),
  Color(0xffdce2f5),
  Color(0xffc7d0f4),
], rangeStart: -20.0, rangeEnd: 20.0);

/*
* Class that builds the column with buttons for both permanent efscore player bar and player changing popup.
* @param buttons: List of Container which will be pub into a ListView
* @param width: Width of column, is bigger for permanent efscore player bar.
* @return: Container with ListView which shows the entries of the input list.
*/
class ButtonBar extends StatelessWidget {
  List<Container> buttons = [];
  late double width;
  late double padWidth;
  ButtonBar({required buttons, required width, required padWidth}) {
    this.buttons = buttons;
    this.width = width;
    this.padWidth = padWidth;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padWidth),
      width: width.toDouble(),
      height: (buttons.length * lineAndButtonHeight + paddingWidth).toDouble(),
      decoration: BoxDecoration(
          color: Colors.white,
          // set border so corners can be made round
          border: Border.all(
            color: Colors.white,
          ),
          // make round edges
          borderRadius: BorderRadius.all(Radius.circular(menuRadius))),
      // ListView which has all given Container-Buttons as entries
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return buttons[index];
        },
        // line between the buttons
        separatorBuilder: (BuildContext context, int index) => Divider(
          color: Colors.white,
          height: paddingWidth,
        ),
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
    final TempController gameController = Get.find<TempController>();

    List<Container> buttons = [];
    for (int i = 0; i < getOnFieldIndex().length; i++) {
      Container button = buildPlayerButton(context, i);
      buttons.add(button);
    }
    return ButtonBar(
      buttons: buttons,
      width: scorebarWidth,
      padWidth: 0.0,
    );
  }
}

// Opens a popup menu besides the Efscorebar.
// @param buttons: Buttons to be displayed in popup
// @param i: index of button to adapt the vertical position so the popup opens besides the pressed button.
void showPopup(BuildContext context, List<Container> buttons, int i) {
  final TempController gameController = Get.find<TempController>();
  int topPadding = i < 3
      ? max((i - (buttons.length / 2).truncate()), 0)
      : max((i - (buttons.length / 2).round()), 0);
  topPadding = buttons.length == 1 ? i : topPadding;
  showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(

                // Make round borders.
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(menuRadius),
                ),

                // Set padding to all sides, so the popup has the needed size and position.
                insetPadding: EdgeInsets.only(
                    // The dialog should appear on the right side of Efscore bar, so the padding on the left side need to be around width of scorebar.
                    left: fieldSizeParameter.screenWidth -
                        (fieldSizeParameter.fieldWidth +
                            paddingWidth * 4 -
                            scorebarWidth) -
                        scorebarWidth,
                    // As the dialog has also width = popupWidth, the right side padding is whole screenWidth-2*popupWidth
                    right: fieldSizeParameter.fieldWidth +
                        paddingWidth * 2 -
                        scorebarWidth,
                    // The dialog should open below the toolbar and other padding. Depending on the position (=index i) of the pressed button,
                    // the top padding changes, so the dialog opens more or less besides the pressed button.
                    top: fieldSizeParameter.toolbarHeight +
                        fieldSizeParameter.paddingTop +
                        topPadding * lineAndButtonHeight -
                        paddingWidth * 6,
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
                    return ButtonBar(
                      buttons: buttons,
                      width: scorebarWidth,
                      padWidth: paddingWidth,
                    );
                  },
                ));
          })
      // When closing check if Popup closes because the plus button was pressed (=> player is still selected on efscore bar)
      // or because of other reasons (chose a player for substitution or just pressed anywhere in screen => player is unselected)
      .then((_) =>
          plusPressed ? null : gameController.setPlayerToChange(Player()));
}

/// builds a single button which represents a player on efscore player bar
/// @param i: Index of player that is represented in playerBarPlayers
/// @return Container with TextButton representing the player.
///         On pressing the button a new popup with possible substitute player pops up.
Container buildPlayerButton(BuildContext context, int i) {
  final TempController gameController = Get.find<TempController>();

  // Get player which have at least one of the given positions.
  List<Player> playerWithSamePosition(List<String> positions) {
    List<Player> substitutePlayer = [];
    for (int k in getNotOnFieldIndex()) {
      for (String position in positions) {
        Player player = gameController.getPlayersFromSelectedTeam()[k];
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
    gameController.setPlayerToChange(gameController
        .getPlayersFromSelectedTeam()[gameController.getPlayerBarPlayers()[i]]);
    gameController.refresh();

    // Build buttons out of players that are not on field and have the same position as pressed player.
    List<Player> players = playerWithSamePosition(gameController
        .getPlayersFromSelectedTeam()[gameController.getPlayerBarPlayers()[i]]
        .positions);
    List<Container> buttons = [];
    for (int k = 0; k < players.length; k++) {
      int l = gameController.getPlayersFromSelectedTeam().indexOf(players[k]);
      Container button = buildPopupPlayerButton(context, l);
      buttons.add(button);
    }
    // Add the button with the plus here.
    buttons.add(buildPlusButton(context, i));

    // Open popup dialog.
    // int i: Index of player in playerbar
    showPopup(context, buttons, i);
  }

  // build buttons for permanent bar with efscore
  return Container(
    decoration: BoxDecoration(

        // make round edges
        borderRadius: BorderRadius.all(Radius.circular(buttonRadius))),
    height: buttonHeight,
    child: Stack(
      children: [
        Obx(
          () => getButton(gameController.getPlayersFromSelectedTeam()[
              gameController.getPlayerBarPlayers()[i]]),
        ),
        SizedBox(
          height: buttonHeight,
          width: scorebarButtonWidth,
          child: TextButton(
            child: const Text(""),
            onPressed: () {
              popupSubstitutePlayer();
            },
            style: TextButton.styleFrom(
              // Color of pressed player changes on efscore bar.
              backgroundColor: Colors.transparent,
              // make round button edges
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(buttonRadius),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

/// builds a single button which represents a player on popup menu.
/// @param i: Index of player that is represented by the button of gameController.getSelectedPlayersFromSelectedTeam().
/// @return Container with TextButton representing the player.
///         The index of player which button was pressed in gameController.getOnFieldPlayers() is changed with index of player
///           with index i in gameController.getSelectedPlayersFromSelectedTeam().
Container buildPopupPlayerButton(BuildContext context, int i) {
  final TempController gameController = Get.find<TempController>();

  // Changes player which was pressed in the efscore bar (gameController.getPlayerToChange)
  // with a player which was pressed in a popup dialog.
  void changePlayer() {
    // get index of player which was pressed in efscore bar in gameController.getOnFieldPlayers()
    int k = gameController
        .getOnFieldPlayers()
        .indexOf(gameController.getPlayerToChange());
    // Change the player which was pressed in efscore bar in gameController.getOnFieldPlayers()
    // to the player which was pressed in popup dialog.
    gameController.setOnFieldPlayer(
        k, gameController.getPlayersFromSelectedTeam()[i]);
    // Update player bar players
    int l = gameController
        .getPlayersFromSelectedTeam()
        .indexOf(gameController.getPlayerToChange());
    int indexToChange = gameController.getPlayerBarPlayers().indexOf(l);
    gameController.getPlayerBarPlayers()[indexToChange] = i;
    gameController.refresh();
  }

  // build button for popup
  return Container(
    decoration: BoxDecoration(

        // make round edges
        borderRadius: BorderRadius.all(Radius.circular(buttonRadius))),
    height: buttonHeight,
    width: scorebarButtonWidth,
    child: Stack(
      children: [
        Obx(
          () => getButton(gameController.getPlayersFromSelectedTeam()[i]),
        ),
        SizedBox(
          height: buttonHeight,
          width: scorebarButtonWidth,
          child: TextButton(
            child: const Text(""),
            onPressed: () {
              changePlayer();
              Navigator.pop(context, true);
              gameController.setPlayerToChange(Player());
            },
            style: TextButton.styleFrom(
              // Color of pressed player changes on efscore bar.
              backgroundColor: Colors.transparent,
              // make round button edges
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(buttonRadius),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Row getButton(Player player) {
  final TempController gameController = Get.find<TempController>();

  return Row(
    children: [
      // Playernumber
      Container(
        // width is 1/5 of button width
        width: scorebarButtonWidth / 5,
        height: buttonHeight,
        alignment: Alignment.center,

        decoration: BoxDecoration(
            color: gameController.getPlayerToChange() == player
                ? pressedButtonColor
                : buttonColor,
            // make round edges
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(buttonRadius),
              topLeft: Radius.circular(buttonRadius),
            )),
        child: Text(
          (player.number).toString(),
          style: TextStyle(
            color: Colors.black,
            fontSize: numberFontSize,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.left,
        ),
      ),

      // Playername
      Expanded(
        child: Container(
          // width is 3/5 of button width
          width: scorebarButtonWidth / 5 * 3,
          height: buttonHeight,
          alignment: Alignment.center,
          color: gameController.getPlayerToChange() == player
              ? pressedButtonColor
              : buttonColor,
          child: Text(
            player.lastName,
            style: TextStyle(color: Colors.black, fontSize: nameFontSize),
            textAlign: TextAlign.left,
          ),
        ),
      ),

      Container(
        width: scorebarButtonWidth / 5,
        height: buttonHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: rb[player.efScore.score],
            // make round edges
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(buttonRadius),
              topRight: Radius.circular(buttonRadius),
            )),
        child: Text(
          player.efScore.score.toStringAsFixed(1),
          style: TextStyle(
            color: Colors.black,
            fontSize: nameFontSize,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    ],
  );
}

// Builds the plus button which is only present in popup.
Container buildPlusButton(BuildContext context, int i) {
  // Popup after clicking on plus at popup dialog.
  // Shows all player which are not on field.
  void popupAllPlayer() {
    List<Container> buttons = [];
    for (int i in getNotOnFieldIndex()) {
      Container button = buildPopupPlayerButton(context, i);
      buttons.add(button);
    }
    showPopup(context, buttons, i);
  }

  return Container(
    height: buttonHeight,
    child: TextButton(
      child: Icon(
        Icons.add,
        // Color of the +
        color: Color.fromARGB(255, 97, 97, 97),
        size: buttonHeight * 0.7,
      ),
      onPressed: () {
        plusPressed = true;
        Navigator.pop(context);
        popupAllPlayer();
      },
      style: TextButton.styleFrom(
        backgroundColor: buttonColor,
        // make round button edges
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(buttonRadius)),
        ),
      ),
    ),
  );
}
