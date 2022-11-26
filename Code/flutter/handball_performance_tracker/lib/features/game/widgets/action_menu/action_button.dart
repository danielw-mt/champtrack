import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/constants/stringsGameScreen.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/core/constants/game_actions.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';
import 'package:handball_performance_tracker/core/constants/positions.dart';

/// @return
/// builds a single dialog button that logs its actiontag to firestore
//  and updates the game state. Its color and icon can be specified as parameters
// @params - sizeFactor: 0 for small buttons, 1 for middle big buttons, 2 for long buttons, anything else for big buttons
//         - otherText: Text to display if it should not equal the text in actionMapping

// TODO move all the BL to bloc
class ActionButton extends StatelessWidget {
  final BuildContext buildContext;
  final String buttonText;
  final Color buttonColor;
  int? sizeFactor;
  Icon? icon;
  String? otherText;
  final String actionTag;
  final String actionContext;
  ActionButton(
      {super.key,
      required this.buildContext,
      required this.actionTag,
      required this.actionContext,
      this.buttonText = "",
      this.buttonColor = Colors.blue,
      this.sizeFactor,
      this.icon,
      this.otherText});

  @override
  Widget build(BuildContext context) {
    final GameBloc gameBloc = context.watch<GameBloc>();
    print("building button $buttonText");
    void handleAction(String actionTag) async {
      DateTime dateTime = DateTime.now();
      int unixTime = dateTime.toUtc().millisecondsSinceEpoch;
      int secondsSinceGameStart = gameBloc.state.stopWatchTimer.secondTime.value;
      // get most recent game id from game state
      // TODO: get game id from gameBloc
      String currentGameId = "";

      // switch field side after hold of goalkeeper
      if (actionTag == paradeTag || actionTag == emptyGoalTag || actionTag == goalOpponentTag) {
        gameBloc.add(SwitchField());
      }
      GameAction action = GameAction(
          teamId: gameBloc.state.selectedTeam.id!,
          gameId: currentGameId,
          context: actionContext,
          tag: actionTag,
          throwLocation: List.from(gameBloc.state.lastClickedLocation.cast<String>()),
          timestamp: unixTime,
          relativeTime: secondsSinceGameStart);
      // store most recent action id in game state for the player menu
      // when a player was selected in that menu the action document can be
      // updated in firebase with their player_id using the action_id

      // if an action inside goalkeeper menu that does not correspond to the opponent was hit try to assign this action directly to the goalkeeper
      if (actionContext == actionContextGoalkeeper && actionTag != goalOpponentTag && actionTag != emptyGoalTag) {
        List<Player> goalKeepers = [];
        gameBloc.state.onFieldPlayers.forEach((Player player) {
          if (player.positions.contains(goalkeeperPos)) {
            goalKeepers.add(player);
          }
        });
        // if there is only one player with a goalkeeper position on field right now assign the action to him
        if (goalKeepers.length == 1) {
          // we know the player id so we assign it here. For all other actions it is assigned in the player menu
          action.playerId = goalKeepers[0].id!;
          gameBloc.add(RegisterAction(actionTag: actionTag));
          Navigator.pop(context);
          // if there is more than one player with a goalkeeper position on field right now
        } else {
          gameBloc.add(UpdatePlayerMenuHintText(hintText: StringsGameScreen.lChooseGoalkeeper));
          gameBloc.add(RegisterAction(actionTag: actionTag));
          Navigator.pop(context);
          // TODO call player menu
          // callPlayerMenu(context);
        }
      }
      if (action.tag == goalTag) {}
      if (action.tag == oneVOneSevenTag) {
        gameBloc.add(UpdateActionMenuHintText(hintText: StringsGameScreen.lChoose7mReceiver));
      }
      if (action.tag == foulSevenMeterTag) {
        gameBloc.add(UpdateActionMenuHintText(hintText: StringsGameScreen.lChoose7mCause));
      }
      if (action.tag == goalOpponentTag || action.tag == emptyGoalTag) {
        gameBloc.add(ChangeScore(score: gameBloc.state.opponentScore + 1, isOwnScore: false));
        // we can add a gameaction here to DB because the player does not need to be selected in the player menu later
        action.playerId = "opponent";
        gameBloc.add(RegisterAction(actionTag: actionTag));
        Navigator.pop(context);
      }
      // don't show player menu if a goalkeeper action or opponent action was logged
      // for all other actions show player menu
      if (actionContext != actionContextGoalkeeper && actionTag != goalOpponentTag) {
        Navigator.pop(context);
        // TODO callPlayerMenu
        // callPlayerMenu(context);
        gameBloc.add(RegisterAction(actionTag: actionTag));
      }
    }

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    double buttonWidth;
    double buttonHeight;
    if (sizeFactor == 0) {
      // Small buttons, eg red and yellow card
      buttonWidth = width * 0.07;
      buttonHeight = buttonWidth;
    } else if (sizeFactor == 1) {
      // Middle big buttons, eg 2m
      buttonWidth = width * 0.13;
      buttonHeight = buttonWidth;
    } else if (sizeFactor == 2) {
      // Long buttons like in goalkeeper menu
      buttonWidth = width * 0.25;
      buttonHeight = width * 0.17;
      // if no size factor provided
    } else {
      // Big buttons like goal
      buttonWidth = width * 0.17;
      buttonHeight = buttonWidth;
    }
    return GestureDetector(
        child: Container(
          margin: sizeFactor == 0 // less margin for smallest buttons
              ? EdgeInsets.all(min(height, width) * 0.013)
              : EdgeInsets.all(min(height, width) * 0.02),
          decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(15)), color: buttonColor),
          // have round edges with same degree as Alert dialog
          // set height and width of buttons so the shirt and name are fitting inside
          height: buttonHeight,
          width: buttonWidth,
          child: Center(
            child: Column(
              children: [
                // if icon is null use a container
                icon ?? Container(),
                Text(
                  // if otherText is null use buttonText
                  otherText ?? buttonText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
        ),
        onTap: () {
          gameBloc.add(RegisterAction(actionTag: actionTag));
        });
  }
}
