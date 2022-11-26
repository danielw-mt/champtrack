import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/constants/game_actions.dart';
import 'package:handball_performance_tracker/old-utils/field_control.dart';
import 'package:handball_performance_tracker/old-utils/icons.dart';
import 'package:handball_performance_tracker/old-utils/player_helper.dart';
import '../../../../old-widgets/main_screen/ef_score_bar.dart';
import '../../../../old-widgets/main_screen/seven_meter_menu.dart';
import 'package:handball_performance_tracker/core/constants/stringsGeneral.dart';
import 'package:handball_performance_tracker/core/constants/stringsGameScreen.dart';
import '../../../../old-widgets/main_screen/seven_meter_player_menu.dart';
import '../../../../old-widgets/main_screen/field.dart';
import 'dart:math';
// import '../../old-utils/feed_logic.dart';
import 'package:handball_performance_tracker/data/models/game_action_model.dart';
import 'package:handball_performance_tracker/data/models/player_model.dart';
import 'package:handball_performance_tracker/core/constants/design_constants.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerButton extends StatelessWidget {
  Player player;
  PlayerButton({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final GameBloc gameBloc = context.read<GameBloc>();
    String buttonText = player.lastName;
    String buttonNumber = player.number.toString();

    Color buttonColor = Color(0);
    Column buttonContent = Column();
    // assist button
    if (gameBloc.state.previousClickedPlayer == player && gameBloc.state.gameActions.last.tag == assistTag) {
      buttonColor = Colors.purple;
      buttonContent = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            StringsGameScreen.lNoAssist,
            style: TextStyle(
              color: Colors.black,
              fontSize: (MediaQuery.of(context).size.width * 0.03),
              fontWeight: FontWeight.bold,
            ),
          ),
          // Shirt
        ],
      );
    } else if (gameBloc.state.penalizedPlayers.contains(player)) {
      buttonColor = Colors.grey;
      // normal dialog button that has a shirt
    } else {
      buttonColor = Color.fromARGB(255, 180, 211, 236);
      buttonContent = Column(
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
                  fontSize: (MediaQuery.of(context).size.width * 0.03),
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Shirt
              Center(
                child: Icon(
                  MyFlutterApp.t_shirt,
                  // make shirt smaller if there are more than 7 player displayed
                  // TODO implement this don't do conditional rendering here but build the body with another if statement
                  // size: (isNotOnField == null || getNotOnFieldIndex().length <= 7)
                  //     ? (MediaQuery.of(context).size.width * 0.11)
                  //     : (MediaQuery.of(context).size.width * 0.11 / getNotOnFieldIndex().length * 7),
                ),
              ),
            ],
          ),
          // ButtonName
          Text(
            buttonText,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontSize: (MediaQuery.of(context).size.width * 0.02),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(color: buttonColor, borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: buttonContent,
        // have some space between the buttons
        margin: EdgeInsets.all(min(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width) * 0.013),
        // have round edges with same degree as Alert dialog
        // set height and width of buttons so the shirt and name are fitting inside
        height: MediaQuery.of(context).size.width * 0.14,
        width: MediaQuery.of(context).size.width * 0.14,
      ),
      onTap: () {
        // TODO handlePlayerSelection
        // substitute player if required
      },
    );
  }
}

/// @return "" if action wasn't a goal, "solo" when player scored without
/// assist and "assist" when player click was assist
// bool _wasAssist() {
//   // check if action was a goal
//   // if it was a goal allow the player to be pressed twice or select and assist player
//   // if the player is clicked again it is a solo action
//   if (gameBloc.state.previousClickedPlayer.id == playerFromButton.id) {
//     return false;
//   }
//   if (gameBloc.state.previousClickedPlayer.id != playerFromButton.id) {
//     return true;
//   }
//   return false;
// }

/// builds a single dialog button that logs its text (=player name) to firestore
/// and updates the game state
// Widget buildDialogButton(BuildContext context, Player playerFromButton, [substitute_menu, isNotOnField]) {
  // Get width and height, so the sizes can be calculated relative to those. So it should look the same on different screen sizes.
  // final double width = MediaQuery.of(context).size.width;
  // final double height = MediaQuery.of(context).size.height;

  // TODO implement this in BLOC. Maybe we can just use switch field and switch to the opposite that the field is on right now
  // void _setFieldBasedOnLastAction(GameAction lastAction) {
  //   if (lastAction.tag == goalTag || lastAction.tag == missTag || lastAction.tag == trfTag) {
  //     // offensiveFieldSwitch();
  //   } else if (lastAction.tag == blockAndStealTag) {
  //     // defensiveFieldSwitch();
  //   }
  // }

  // TODO handle this in BLOC
  // void handlePlayerSelection() async {
  //   GameAction lastAction = gameBloc.state.gameActions.last;
  //   Player previousClickedPlayer = gameBloc.state.previousClickedPlayer;
  //   // if goal was pressed but no player was selected yet
  //   //(lastClickedPlayer is default Player Object) do nothing
  //   if (lastAction.tag == goalTag && previousClickedPlayer.id! == "") {
  //     gameBloc.add(UpdatePlayerMenuHintText(hintText: "TODO Assist"));
  //     // update last Clicked player value with the Player from selected team
  //     // who was clicked
  //     gameBloc.add(RegisterClickOnPlayer(player: playerFromButton));
  //     return;
  //   }
  //   // if goal was pressed and a player was already clicked once
  //   if (lastAction.tag == goalTag) {
  //     // if it was a solo goal the action type has to be updated to "Tor Solo"
  //     persistentController.setLastActionPlayer(previousClickedPlayer);
  //     tempController.updatePlayerEfScore(previousClickedPlayer.id!, persistentController.getLastAction());
  //     addFeedItem(persistentController.getLastAction());
  //     tempController.incOwnScore();
  //     // add goal to feed
  //     // if it was a solo goal the action type has to be updated to "Tor Solo"

  //     if (!_wasAssist()) {
  //       // don't need to do anything because ID was already set above
  //     } else {
  //       // person that scored assist
  //       // deep clone a new action from the most recent action
  //       GameAction assistAction = GameAction.clone(lastAction);
  //       print("assist action: $assistAction");
  //       assistAction.tag = assistTag;
  //       persistentController.addActionToCache(assistAction);
  //       Player assistPlayer = playerFromButton;
  //       assistAction.playerId = assistPlayer.id!;
  //       persistentController.setLastActionPlayer(assistPlayer);
  //       tempController.updatePlayerEfScore(assistPlayer.id!, persistentController.getLastAction());

  //       // add assist first to the feed and then the goal
  //       addFeedItem(assistAction);
  //       tempController.setPreviousClickedPlayer(Player());
  //     }
  //   } else {
  //     // if the action was not a goal just update the player id in firebase and gamestate
  //     persistentController.setLastActionPlayer(playerFromButton);
  //     tempController.setPreviousClickedPlayer(playerFromButton);
  //     tempController.updatePlayerEfScore(playerFromButton.id!, persistentController.getLastAction());
  //     // add action to feed
  //     lastAction.playerId = playerFromButton.id!;
  //     addFeedItem(persistentController.getLastAction());
  //     persistentController.addActionToCache(lastAction);
  //   }

  //   ///
  //   // start: time penalty logic
  //   // if you click on a penalized player the time penalty is removed
  //   ///
  //   if (tempController.isPlayerPenalized(playerFromButton)) {
  //     tempController.removePenalizedPlayer(playerFromButton);
  //   }
  //   if (lastAction.tag == timePenaltyTag) {
  //     Player player = tempController.getPreviousClickedPlayer();
  //     tempController.addPenalizedPlayer(player);
  //   }

  //   ///
  //   // end: time penalty logic
  //   ///

  //   // Check if associated player or lastClickedPlayer are notOnFieldPlayer. If yes, player menu appears to change the player.
  //   // We can click on not on field players if we swipe on the player menu and all the player not on field will be shown.
  //   if (!tempController.getOnFieldPlayers().contains(playerFromButton)) {
  //     tempController.addPlayerToChange(playerFromButton);
  //   }
  //   if (!tempController.getOnFieldPlayers().contains(previousClickedPlayer) && !(previousClickedPlayer.id! == "")) {
  //     tempController.addPlayerToChange(previousClickedPlayer);
  //   }
  //   _setFieldBasedOnLastAction(lastAction);
  //   // If there are still player to change, open the player menu again but as a substitue player menu (true flag)
  //   if (!tempController.getPlayersToChange().isEmpty) {
  //     Navigator.pop(context);
  //     callPlayerMenu(context, true);
  //     return;
  //   }

  //   // if we get a 7m in our favor call the seven meter menu for us
  //   if (lastAction.tag == oneVOneSevenTag) {
  //     Navigator.pop(context);
  //     callSevenMeterPlayerMenu(context);
  //     return;
  //   }
  //   // if we perform a 7m foul call the seven meter menu for the other team
  //   else if (lastAction.tag == foulSevenMeterTag) {
  //     Navigator.pop(context);
  //     callSevenMeterMenu(context, false);
  //     return;
  //   }
  //   // reset last clicked player and player menu hint text
  //   tempController.setPreviousClickedPlayer(Player());
  //   tempController.setPlayerMenuText("");
  //   Navigator.pop(context);
  // }

  // function which is called is substitute_player param is not null
  // after a player was chosen for an action who is not on field

  // TODO move this to BLOC and adapt the button to substitute or not
  // void substitutePlayer() {
  //   playerChanged = true;
  //   // get player which was pressed in player menu in tempController.getOnFieldPlayers()
  //   Player playerToChange = tempController.getLastPlayerToChange();

  //   // Update player bar players
  //   int l = tempController.getPlayersFromSelectedTeam().indexOf(playerToChange);
  //   int k = tempController.getPlayersFromSelectedTeam().indexOf(playerFromButton);
  //   int indexToChange = tempController.getPlayerBarPlayers().indexOf(k);
  //   tempController.changePlayerBarPlayers(indexToChange, l);
  //   // Change the player which was pressed in player menu in tempController.getOnFieldPlayers()
  //   // to the player which was pressed in popup dialog.
  //   tempController.setOnFieldPlayer(
  //       tempController.getOnFieldPlayers().indexOf(playerFromButton), playerToChange, Get.find<PersistentController>().getCurrentGame());

  //   tempController.setPlayerMenuText("");
  //   Navigator.pop(context);
  // }

  // Button with shirt with buttonNumber inside and buttonText below.
  // Getbuilder so the color changes if player == goalscorer,
// }
