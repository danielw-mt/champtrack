import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/controllers/globalController.dart';
import 'package:handball_performance_tracker/data/player.dart';
import 'package:handball_performance_tracker/utils/fieldSizeParameter.dart'
    as fieldSizeParameter;
import 'package:handball_performance_tracker/utils/player_helper.dart';
import 'dart:math';
import 'package:rainbow_color/rainbow_color.dart';

// Radius of round edges
double menuRadius = 10.0;
double buttonRadius = 5.0;
// Width of padding between buttons
double paddingWidth = 8.0;
// height of button + line between buttons.
double lineAndButtonHeight = fieldSizeParameter.fieldHeight / 7;
// height of a button -> The full height should be used when 7 buttons are displayed.
double buttonHeight = (fieldSizeParameter.fieldHeight - paddingWidth * 9) / 7;
// width of popup
double popupWidth = buttonHeight + 3 * paddingWidth;
// width of efscore bar
double scorebarWidth = popupWidth * 2;
// width of a button in scorebar
double scorebarButtonWidth = scorebarWidth - 10 * paddingWidth;
// track if plus button was pressed, so the adapted color of the pressed player on efscore bar does not change back to normal already.
bool plusPressed = false;
// Color of unpressed button
Color buttonColor = Color.fromARGB(255, 216, 216, 216);
// Color of pressed button
Color pressedButtonColor = Colors.blue;
double numberFontSize = 23;
double nameFontSize = 16;
// Spectrum for color coding of efscore
var rb = Rainbow(spectrum: [
  Color(0xffff6600),
  Color(0xffffaa00),
  Color(0xffffaa00),
  Color(0xffd0ff00),
  Color(0xff1fff00),
], rangeStart: 0.0, rangeEnd: 30.0);

/*
* Class that builds the column with buttons for both permanent efscore bar and player changing popup.
* @param buttons: List of Container which will be pub into a ListView
* @return: Container with ListView which shows the entries of the input list.
*/
class ButtonBar extends StatelessWidget {
  List<Container> buttons = [];
  late double width;
  ButtonBar({required buttons, required width}) {
    this.buttons = buttons;
    this.width = width;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(paddingWidth),
      width: width,
      height: buttons.length * lineAndButtonHeight,
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
    final GlobalController globalController = Get.find<GlobalController>();

    List<Container> buttons = [];
    for (int i in getOnFieldIndex()) {
      Container button = buildPlayerButton(context, i, true);
      buttons.add(button);
    }
    return ButtonBar(
      buttons: buttons,
      width: scorebarWidth,
    );
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
                  borderRadius: BorderRadius.circular(menuRadius),
                ),

                // Set padding to all sides, so the popup has the needed size and position.
                insetPadding: EdgeInsets.only(
                    // The dialog should appear on the right side of Efscore bar, so the padding on the left side need to be around width of scorebar.
                    left: scorebarWidth * 0.7,
                    // As the dialog has also width = popupWidth, the right side padding is whole screenWidth-2*popupWidth
                    right: fieldSizeParameter.screenWidth -
                        scorebarWidth * 0.7 -
                        popupWidth,
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
                    return ButtonBar(
                      buttons: buttons,
                      width: popupWidth,
                    );
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
/// @param i: Index of player that is represented by the button of globalController.chosenPlayers.
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
    for (int k in getNotOnFieldIndex()) {
      for (String position in positions) {
        Player player = globalController.chosenPlayers[k];
        if (player.position.contains(position)) {
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
    globalController.playerToChange.value = globalController.chosenPlayers[i];
    globalController.refresh();

    // Build buttons out of players that are not on field and have the same position as pressed player.
    List<Player> players =
        playerWithSamePosition(globalController.chosenPlayers[i].position);
    List<Container> buttons = [];
    for (int k = 0; k < players.length; k++) {
      int l = globalController.chosenPlayers.indexOf(players[k]);
      Container button = buildPlayerButton(context, l, false);
      buttons.add(button);
    }
    // Add the button with the plus here.
    buttons.add(buildPlusButton(context));
    // get index of player in playerbar
    int buttonIndex = 0;
    for (int k = 0; k < getOnFieldIndex().length; k++) {
      if (i == getOnFieldIndex()[k]) {
        buttonIndex = k;
      }
    }
    // Open popup dialog.
    showPopup(context, buttons, buttonIndex);
  }

  // Changes player which was pressed in the efscore bar (globalController.playerToChange)
  // with a player which was pressed in a popup dialog.
  void changePlayer() {
    // get index of player which was pressed in efscore bar in globalController.chosenPlayers
    int k = globalController.chosenPlayers
        .indexOf(globalController.playerToChange.value);
    // Change the player which was pressed in efscore bar in globalController.chosenPlayers to the player which was pressed in popup dialog.
    globalController.chosenPlayers[k] = globalController.chosenPlayers[i];

    // Change the player which was pressed in popup dialog in globalController.playersNotOnField to the player which was pressed in efscore bar.
    globalController.chosenPlayers[i] = globalController.playerToChange.value;

    globalController.refresh();
  }

  Container buttonContainer;
  if (isPermanentBar) {
    // build buttons for permanent bar with efscore
    buttonContainer = Container(
      height: buttonHeight,
      // Use Obx, so the button adapts to globalController values once they are changed.
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Playernumber
                    SizedBox(
                      // width is 1/5 of button width
                      width: scorebarButtonWidth / 5,
                      child: Text(
                        (globalController.chosenPlayers[i].number).toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: numberFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const VerticalDivider(),
                    // Playername
                    SizedBox(
                      // width is 3/5 of button width
                      width: scorebarButtonWidth / 5 * 3,
                      child: Text(
                        globalController.chosenPlayers[i].name,
                        style: TextStyle(
                            color: Colors.black, fontSize: nameFontSize),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const VerticalDivider(),
                    // Efscore
                    SizedBox(
                      // width is 1/5 of button width
                      width: scorebarButtonWidth / 5,
                      child: Text(
                        // TODO change to real efscore
                        "-2,8",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: nameFontSize,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  popupSubstitutePlayer();
                },
                style: TextButton.styleFrom(
                  // Color of pressed player changes on efscore bar.
                  backgroundColor: globalController.playerToChange.value ==
                          globalController.chosenPlayers[i]
                      ? pressedButtonColor
                      : buttonColor,
                  // make round button edges
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(buttonRadius),
                      bottomLeft: Radius.circular(buttonRadius),
                    ),
                  ),
                ),
              ),
            ),
            // Container with Colorcoding by efscore
            Container(
              height: buttonHeight,
              width: scorebarButtonWidth / 30,
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                  // TODO: change number by efscore (right now the it colors by playernumber)
                  color: rb[globalController.chosenPlayers[i].number],
                  // set border so corners can be made round
                  border: Border.all(
                    color: rb[globalController.chosenPlayers[i].number],
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(buttonRadius),
                    bottomRight: Radius.circular(buttonRadius),
                  )),
              child: Text(""),
            ),
          ],
        ),
      ),
    );
  } else {
    // build button for popup
    buttonContainer = Container(
      height: buttonHeight,
      // Use Obx, so the button adapts to globalController values once they are changed.
      child: Obx(
        () => TextButton(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                globalController.chosenPlayers[i].name,
                style: TextStyle(color: Colors.black, fontSize: nameFontSize),
                textAlign: TextAlign.center,
              ),
              Text(
                (globalController.chosenPlayers[i].number).toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: numberFontSize,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
          onPressed: () {
            changePlayer();
            Navigator.pop(context, true);
            globalController.playerToChange.value = Player();
          },
          style: TextButton.styleFrom(
            backgroundColor: buttonColor,
            // make round button edges
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(buttonRadius)),
            ),
          ),
        ),
      ),
    );
  }
  return buttonContainer;
}

// Builds the plus button which is only present in popup.
Container buildPlusButton(BuildContext context) {
  final GlobalController globalController = Get.find<GlobalController>();
  // Popup after clicking on plus at popup dialog.
  // Shows all player which are not on field.
  void popupAllPlayer() {
    List<Container> buttons = [];
    for (int i in getNotOnFieldIndex()) {
      Container button = buildPlayerButton(context, i, false);
      buttons.add(button);
    }
    showPopup(context, buttons, 0);
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
