import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/constants/game_actions.dart';
import 'package:handball_performance_tracker/core/constants/strings_general.dart';
import 'package:handball_performance_tracker/data/models/game_model.dart';
import 'package:handball_performance_tracker/data/models/player_model.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/core/constants/design_constants.dart';
import 'package:handball_performance_tracker/core/constants/strings_game_screen.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/core/constants//game_actions.dart';
import 'dart:math';
import 'package:handball_performance_tracker/core/constants/positions.dart';

void callSevenMeterMenu(BuildContext context, bool belongsToHomeTeam) {

  showDialog(
      context: context,
      builder: (BuildContext bcontext) {
        return AlertDialog(
            scrollable: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MENU_RADIUS),
            ),

            // alert contains a list of DialogButton objects
            content: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  Expanded(child: buildDialogButtonMenu(bcontext, belongsToHomeTeam)),
                ] // Column of "Player", horizontal line and Button-Row
                    )));
      });
}

/// @return a menu of the 2 7 meter outcomes with different text depending
/// whether it belongs to the home team or opponent team
Widget buildDialogButtonMenu(BuildContext context, bool belongsToHomeTeam) {
  List<SevenMeterMenuButton> dialogButtons = [];
  if (belongsToHomeTeam) {
    dialogButtons = [
      SevenMeterMenuButton(icon: Icon(Icons.style), actionTag: goal7mTag, buttonText: StringsGameScreen.lGoal, buttonColor: Colors.lightBlue),
      SevenMeterMenuButton(icon: Icon(Icons.style), actionTag: missed7mTag, buttonText: StringsGameScreen.lErrThrow, buttonColor: Colors.deepPurple)
    ];
  } else {
    dialogButtons = [
      SevenMeterMenuButton(icon: Icon(Icons.style), actionTag: goalOpponent7mTag, buttonText: StringsGameScreen.lGoalOpponent, buttonColor: Colors.red),
      SevenMeterMenuButton(icon: Icon(Icons.style), actionTag: parade7mTag, buttonText: StringsGeneral.lCaught, buttonColor: Colors.yellow)
    ];
  }
  return Column(children: [
    Row(
      children: [Icon(Icons.sports_handball), Text(StringsGeneral.lSevenMeter)],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            StringsGameScreen.lOffensePopUpHeader,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.black,
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
    Row(children: [dialogButtons[0], dialogButtons[1]])
  ]);
}

class SevenMeterMenuButton extends StatelessWidget {
  Icon icon;
  String actionTag;
  String buttonText;
  Color buttonColor;
  SevenMeterMenuButton({super.key, required this.icon, required this.actionTag, required this.buttonText, required this.buttonColor});

  @override
  Widget build(BuildContext context) {
    final GameBloc gameBloc = context.read<GameBloc>();
    final double width = MediaQuery.of(context).size.width;
  final double height = MediaQuery.of(context).size.height;
  return GestureDetector(
    child: Container(
        margin: EdgeInsets.all(min(height, width) * 0.013),
        decoration: BoxDecoration(
          color: buttonColor,
          // have round edges with same degree as Alert dialog
          borderRadius: BorderRadius.circular(15),
        ),
        
        // set height and width of buttons so the shirt and name are fitting inside
        height: width * 0.15,
        width: width * 0.15,
        child: Center(
          child: Column(
            children: [
              icon,
              Text(
                buttonText,
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
    ), onTap:() {
      gameBloc.add(RegisterAction(actionTag: actionTag, actionContext: actionContextSevenMeter));
    },
  );
  }
}


/// @return
/// builds a single dialog button that logs its text (=action) to firestore
//  and updates the game state. Its color and icon can be specified as parameters
// DialogButton buildDialogButton(BuildContext context, String actionTag, String buttonText, Color color, [icon]) {
  
  // TODO move this to BLOC
  // void logAction() async {
  //   logger.d("logging an action");
  //   DateTime dateTime = DateTime.now();
  //   int unixTime = dateTime.toUtc().millisecondsSinceEpoch;
  //   int secondsSinceGameStart = persistentController.getCurrentGame().stopWatchTimer.secondTime.value;

  //   // get most recent game id from DB
  //   String currentGameId = persistentController.getCurrentGame().id!;

  //   GameAction action = GameAction(
  //       teamId: tempController.getSelectedTeam().id!,
  //       gameId: currentGameId,
  //       context: actionContextSevenMeter,
  //       tag: actionTag,
  //       throwLocation: List.from(tempController.getLastLocation().cast<String>()),
  //       timestamp: unixTime,
  //       relativeTime: secondsSinceGameStart);
  //   // we executed a 7m
  //   if (actionTag == goal7mTag || actionTag == missed7mTag) {
  //     logger.d("our team executed a 7m");
  //     Player sevenMeterExecutor = tempController.getPreviousClickedPlayer();
  //     action.playerId = sevenMeterExecutor.id!;
  //     persistentController.addActionToCache(action);
  //     persistentController.addActionToFirebase(action);
  //     tempController.updatePlayerEfScore(action.playerId, action);
  //     addFeedItem(action);
  //     tempController.setPreviousClickedPlayer(Player());
  //     Navigator.pop(context);
  //     // opponents scored or missed their 7m
  //   } else if (actionTag == goalOpponent7mTag || actionTag == parade7mTag) {
  //     logger.d("opponent executed a 7m");
  //     List<Player> goalKeepers = [];
  //     tempController.getOnFieldPlayers().forEach((Player player) {
  //       if (player.positions.contains(goalkeeperPos)) {
  //         goalKeepers.add(player);
  //       }
  //     });
  //     // if there is only one player with a goalkeeper position on field right now assign the action to him
  //     if (goalKeepers.length == 1) {
  //       // we know the player id so we assign it here. For all other actions it is assigned in the player menu
  //       action.playerId = goalKeepers[0].id!;
  //       persistentController.addActionToCache(action);
  //       persistentController.addActionToFirebase(action);
  //       addFeedItem(action);
  //       Navigator.pop(context);
  //       tempController.updatePlayerEfScore(action.playerId, action);
  //       // if there is more than one player with a goalkeeper position on field right now
  //     } else {
  //       tempController.setPlayerMenuText(StringsGameScreen.lChooseGoalkeeper);
  //       logger.d("More than one goalkeeper on field. Waiting for player selection");
  //       persistentController.addActionToCache(action);
  //       Navigator.pop(context);
  //       callPlayerMenu(context);
  //     }
  //   }

  //   // goal
  //   if (actionTag == goal7mTag) {
  //     tempController.incOwnScore();
  //     offensiveFieldSwitch();
  //   }
  //   // missed 7m
  //   if (actionTag == missed7mTag) {
  //     offensiveFieldSwitch();
  //   }
  //   // opponent goal
  //   if (actionTag == goalOpponent7mTag) {
  //     tempController.incOpponentScore();
  //     defensiveFieldSwitch();
  //   }
  //   // opponent missed
  //   if (actionTag == parade7mTag) {
  //     defensiveFieldSwitch();
  //   }

  //   // If there were player clicked which are not on field, open substitute player menu

  //   // see # 400 swapping out player on bench should not be possible
  //   // if (!tempController.getPlayersToChange().isEmpty) {
  //   //   Navigator.pop(context);
  //   //   callPlayerMenu(context, true);
  //   //   return;
  //   // }
  // }
