import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/constants/game_actions.dart';
import 'package:handball_performance_tracker/old-utils/field_control.dart';
import 'package:handball_performance_tracker/old-utils/icons.dart';
import 'package:handball_performance_tracker/old-utils/player_helper.dart';
import '../../../../old-widgets/main_screen/ef_score_bar.dart';
import '../../../../old-widgets/main_screen/seven_meter_menu.dart';
import 'package:handball_performance_tracker/core/constants/strings_general.dart';
import 'package:handball_performance_tracker/core/constants/strings_game_screen.dart';
import '../../../../old-widgets/main_screen/seven_meter_player_menu.dart';
import '../../../../old-widgets/main_screen/field.dart';
import 'dart:math';
// import '../../old-utils/feed_logic.dart';
import 'package:handball_performance_tracker/data/models/game_action_model.dart';
import 'package:handball_performance_tracker/data/models/player_model.dart';
import 'package:handball_performance_tracker/core/constants/design_constants.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'player_grid.dart';

// TODO remove this if it is covered
// Variable is true if the player menu is open. After a player was selected and Navigator.pop
// is called, it is set to false. This is used to know if the menu closes without choosing a player
// by clicking just anywhere in the screen.
// bool playerChanged = false;

// TODO move BL to bloc and only do UI here

/// Substiture menu gets called sometimes then this flag is true
void callPlayerMenu(context) {
  final GameBloc gameBloc = context.read<GameBloc>();
  PageController pageController = PageController();
  bool notOnFieldMenuOpen = false;

  // builds the grid with the players on field and the one with players not on field
  List<PlayersGrid> buildPages() {
    List<PlayersGrid> pages = [];
    pages.add(PlayersGrid(players: gameBloc.state.onFieldPlayers));
    // if we have more players in the team than the ones that are on the field we need to add a page
    if (gameBloc.state.selectedTeam.players.length > gameBloc.state.onFieldPlayers.length) {
      List<Player> playersNotOnField = [];
      for (Player player in gameBloc.state.selectedTeam.players) {
        if (!gameBloc.state.onFieldPlayers.contains(player)) {
          playersNotOnField.add(player);
        }
      }
      pages.add(PlayersGrid(players: playersNotOnField));
    }
    return pages;
  }

  showDialog(
          context: context,
          builder: (BuildContext bcontext) {
            return AlertDialog(
              scrollable: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MENU_RADIUS),
              ),
              // alert contains a list of DialogButton objects
              content:
                  // Column of "Player", horizontal line and Button-Row
                  Column(
                children: [
                  // upper row: "Player" Text on left and "Assist" will pop up on right after a goal.
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
                        child: Text(
                          notOnFieldMenuOpen ? StringsGameScreen.lSubstitute : gameBloc.state.playerMenuHintText,
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
                  // Substitute player text
                  // TODO implement this if substitute menu will be used
                  // Text(
                  //   substitute_menu == null
                  //       ? ""
                  //       : StringsGameScreen.lSubstitute1 + tempController.getPlayersToChange()[0].lastName + StringsGameScreen.lSubstitute2,
                  //   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  // ),

                  // Button-Row: one Row with four Columns of one or two buttons
                  Scrollbar(
                    controller: pageController,
                    thumbVisibility: true,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Expanded(
                        child: PageView(
                          onPageChanged: (value) {
                            if (value == 1) {
                              notOnFieldMenuOpen = true;
                            } else {
                              notOnFieldMenuOpen = false;
                            }
                          },
                          controller: pageController,
                          children: buildPages(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          })
      // When closing set player menu text to ""
      // if just pressed anywhere in screen)
      .then((_) {
    gameBloc.add(UpdatePlayerMenuHintText(hintText: ""));
    gameBloc.add(RegisterPlayerSelection(player: Player()));
    // (!playerChanged && substitute_menu != null) ? gameBloc.state.playerToChange : null; // delete player to change from list if player menu was closed
    // playerChanged = false;
  });
}




// a method for building the children of the pageview with players on field on the first page and all others on the next.
// List<Widget> buildPages(BuildContext context) {
//   final GameBloc gameBloc = context.read<GameBloc>();
//   List<Widget> onFieldButtons = buildDialogButtonOnFieldList(context, substitute_menu);
//   // TODO implement this if substitute menu will be used
//   // List<Widget> notOnFieldButtons = buildDialogButtonNotOnFieldList(context);

//   // Build content for on field player page
//   List<Widget> onFieldDisplay = [];
//   for (int i = 0; i < gameBloc.state.onFieldPlayers.length - 1; i++) {
//     onFieldDisplay.add(Flexible(
//       child: Column(
//         children: [onFieldButtons[i], onFieldButtons[i + 1]],
//       ),
//     ));
//     i++;
//   }
//   // If number of player uneven, add the last which is not inside a row.
//   if (gameBloc.state.onFieldPlayers.length % 2 != 0) {
//     onFieldDisplay.add(onFieldButtons[gameBloc.state.onFieldPlayers.length - 1]);
//   }

//   // Build content for not on field player page
//   // TODO implement this if substitute menu will be used
//   // List<Widget> notOnFieldDisplay = [];
//   // for (int i = 0; i < notOnFieldButtons.length - 1; i++) {
//   //   notOnFieldDisplay.add(Flexible(
//   //     child: Column(
//   //       children: [notOnFieldButtons[i], notOnFieldButtons[i + 1]],
//   //     ),
//   //   ));
//   //   i++;
//   // }

//   // If number of player uneven, add the last which is not inside a row.
//   // TODO implement this if substitute menu will be used
//   // if (notOnFieldButtons.length % 2 != 0) {
//   //   notOnFieldDisplay.add(Flexible(child: notOnFieldButtons[notOnFieldButtons.length - 1]));
//   // }

//   List<Widget> buttonRow = (substitute_menu == null)
//       ? [
//           Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: onFieldDisplay),
//           // TODO implement this if substitute menu will be used
//           //Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: notOnFieldDisplay),
//         ]
//       : [
//           Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: onFieldDisplay),
//         ];
//   return buttonRow;
// }

/// builds a list of Dialog buttons with players which are not on field
/// TODO implement this if substitute menu will be used
// List<GetBuilder<TempController>> buildDialogButtonNotOnFieldList(BuildContext context) {
//   final TempController tempController = Get.find<TempController>();
//   List<GetBuilder<TempController>> dialogButtons = [];
//   for (int i = 0; i < tempController.getSelectedTeam().players.length; i++) {
//     if (tempController.getSelectedTeam().onFieldPlayers.contains(tempController.getSelectedTeam().players[i]) == false) {
//       GetBuilder<TempController> dialogButton = buildDialogButton(context, tempController.getSelectedTeam().players[i], null, true);
//       dialogButtons.add(dialogButton);
//     }
//   }
//   return dialogButtons;
// }

/// builds a list of Dialog buttons with players which are on field
// List buildDialogButtonOnFieldList(BuildContext context, [substitute_menu]) {
//   final GameBloc gameBloc = context.read<GameBloc>();
//   List dialogButtons = [];
//   for (Player player in gameBloc.state.onFieldPlayers) {
//     Widget dialogButton = buildDialogButton(context, player, substitute_menu);
//     dialogButtons.add(dialogButton);
//   }
//   return dialogButtons;
// }


