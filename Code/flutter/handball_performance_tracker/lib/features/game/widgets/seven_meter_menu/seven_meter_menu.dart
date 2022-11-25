// import 'package:flutter/material.dart';
// import 'package:handball_performance_tracker/core/constants/stringsGeneral.dart';
// import 'package:get/get.dart';
// import 'package:handball_performance_tracker/data/models/player_model.dart';
// import 'package:handball_performance_tracker/old-utils/feed_logic.dart';
// import 'package:handball_performance_tracker/old-utils/player_helper.dart';
// import '../../../../old-widgets/main_screen/ef_score_bar.dart';
// import '../../../../old-widgets/main_screen/playermenu.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import '../../core/constants/stringsGameScreen.dart';
// import '../../data/models/game_action_model.dart';
// import '../../core/constants/game_actions.dart';
// import '../../controllers/temp_controller.dart';
// import '../../controllers/persistent_controller.dart';
// import 'dart:math';
// import 'package:logger/logger.dart';
// import '../../old-utils/field_control.dart';
// import '../../core/constants/positions.dart';

// var logger = Logger(
//   printer: PrettyPrinter(
//       methodCount: 2, // number of method calls to be displayed
//       errorMethodCount: 8, // number of method calls if stacktrace is provided
//       lineLength: 120, // width of the output
//       colors: true, // Colorful log messages
//       printEmojis: true, // Print an emoji for each log message
//       printTime: false // Should each log print contain a timestamp
//       ),
// );

// void callSevenMeterMenu(BuildContext context, bool belongsToHomeTeam) {
//   logger.d("Calling 7m menu");

//   showDialog(
//       context: context,
//       builder: (BuildContext bcontext) {
//         return AlertDialog(
//             scrollable: true,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(menuRadius),
//             ),

//             // alert contains a list of DialogButton objects
//             content: Container(
//                 width: MediaQuery.of(context).size.width * 0.4,
//                 height: MediaQuery.of(context).size.height * 0.4,
//                 child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
//                   Expanded(child: buildDialogButtonMenu(bcontext, belongsToHomeTeam)),
//                 ] // Column of "Player", horizontal line and Button-Row
//                     )));
//       });
// }

// /// @return true if attacking false if defending
// bool determineAttack() {
//   logger.d("Determining whether attack actions should be displayed...");
//   final TempController tempController = Get.find<TempController>();
//   // decide whether attack or defense actions should be displayed depending
//   //on what side the team goals is and whether they are attacking or defending
//   bool attacking = false;
//   bool attackIsLeft = tempController.getAttackIsLeft();
//   bool fieldIsLeft = tempController.getFieldIsLeft();

//   // when our goal is to the right (= attackIsLeft) and the field is left
//   //display attack options
//   if (attackIsLeft && fieldIsLeft) {
//     attacking = true;
//     // when our goal is to the left (=attack is right) and the field is to the
//     //right display attack options
//   } else if (attackIsLeft == false && fieldIsLeft == false) {
//     attacking = true;
//   }
//   logger.d("Attack actions should be displayed: $attacking");
//   return attacking;
// }

// /// @return a menu of the 2 7 meter outcomes with different text depending
// /// whether it belongs to the home team or opponent team
// Widget buildDialogButtonMenu(BuildContext context, bool belongsToHomeTeam) {
//   List<DialogButton> dialogButtons = [];
//   if (belongsToHomeTeam) {
//     dialogButtons = [
//       buildDialogButton(context, goal7mTag, StringsGameScreen.lGoal, Colors.lightBlue, Icons.style),
//       buildDialogButton(context, missed7mTag, StringsGameScreen.lErrThrow, Colors.deepPurple, Icons.style),
//     ];
//   } else {
//     dialogButtons = [
//       buildDialogButton(context, goalOpponent7mTag, StringsGameScreen.lGoalOpponent, Colors.red, Icons.style),
//       buildDialogButton(context, parade7mTag, StringsGeneral.lCaught, Colors.yellow, Icons.style)
//     ];
//   }
//   return Column(children: [
//     Row(
//       children: [Icon(Icons.sports_handball), Text(StringsGeneral.lSevenMeter)],
//     ),
//     Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: const [
//         Align(
//           alignment: Alignment.topLeft,
//           child: Text(
//             StringsGameScreen.lOffensePopUpHeader,
//             textAlign: TextAlign.left,
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 20,
//             ),
//           ),
//         ),
//       ],
//     ),
//     // horizontal line
//     const Divider(
//       thickness: 2,
//       color: Colors.black,
//       height: 6,
//     ),
//     // Button-Row: one Row with 3 Columns of 3, 3 and 2 buttons
//     Row(children: [dialogButtons[0], dialogButtons[1]])
//   ]);
// }

// /// @return
// /// builds a single dialog button that logs its text (=action) to firestore
// //  and updates the game state. Its color and icon can be specified as parameters
// DialogButton buildDialogButton(BuildContext context, String actionTag, String buttonText, Color color, [icon]) {
//   final PersistentController persistentController = Get.find<PersistentController>();
//   final TempController tempController = Get.find<TempController>();
//   void logAction() async {
//     logger.d("logging an action");
//     DateTime dateTime = DateTime.now();
//     int unixTime = dateTime.toUtc().millisecondsSinceEpoch;
//     int secondsSinceGameStart = persistentController.getCurrentGame().stopWatchTimer.secondTime.value;

//     // get most recent game id from DB
//     String currentGameId = persistentController.getCurrentGame().id!;

//     GameAction action = GameAction(
//         teamId: tempController.getSelectedTeam().id!,
//         gameId: currentGameId,
//         context: actionContextSevenMeter,
//         tag: actionTag,
//         throwLocation: List.from(tempController.getLastLocation().cast<String>()),
//         timestamp: unixTime,
//         relativeTime: secondsSinceGameStart);
//     // we executed a 7m
//     if (actionTag == goal7mTag || actionTag == missed7mTag) {
//       logger.d("our team executed a 7m");
//       Player sevenMeterExecutor = tempController.getPreviousClickedPlayer();
//       action.playerId = sevenMeterExecutor.id!;
//       persistentController.addActionToCache(action);
//       persistentController.addActionToFirebase(action);
//       tempController.updatePlayerEfScore(action.playerId, action);
//       addFeedItem(action);
//       tempController.setPreviousClickedPlayer(Player());
//       Navigator.pop(context);
//       // opponents scored or missed their 7m
//     } else if (actionTag == goalOpponent7mTag || actionTag == parade7mTag) {
//       logger.d("opponent executed a 7m");
//       List<Player> goalKeepers = [];
//       tempController.getOnFieldPlayers().forEach((Player player) {
//         if (player.positions.contains(goalkeeperPos)) {
//           goalKeepers.add(player);
//         }
//       });
//       // if there is only one player with a goalkeeper position on field right now assign the action to him
//       if (goalKeepers.length == 1) {
//         logger.d("single goalkeeper on field");
//         // we know the player id so we assign it here. For all other actions it is assigned in the player menu
//         action.playerId = goalKeepers[0].id!;
//         persistentController.addActionToCache(action);
//         persistentController.addActionToFirebase(action);
//         addFeedItem(action);
//         Navigator.pop(context);
//         tempController.updatePlayerEfScore(action.playerId, action);
//         // if there is more than one player with a goalkeeper position on field right now
//       } else {
//         tempController.setPlayerMenuText(StringsGameScreen.lChooseGoalkeeper);
//         logger.d("More than one goalkeeper on field. Waiting for player selection");
//         persistentController.addActionToCache(action);
//         Navigator.pop(context);
//         callPlayerMenu(context);
//       }
//     }

//     // goal
//     if (actionTag == goal7mTag) {
//       tempController.incOwnScore();
//       offensiveFieldSwitch();
//     }
//     // missed 7m
//     if (actionTag == missed7mTag) {
//       offensiveFieldSwitch();
//     }
//     // opponent goal
//     if (actionTag == goalOpponent7mTag) {
//       tempController.incOpponentScore();
//       defensiveFieldSwitch();
//     }
//     // opponent missed
//     if (actionTag == parade7mTag) {
//       defensiveFieldSwitch();
//     }

//     // If there were player clicked which are not on field, open substitute player menu

//     // see # 400 swapping out player on bench should not be possible
//     // if (!tempController.getPlayersToChange().isEmpty) {
//     //   Navigator.pop(context);
//     //   callPlayerMenu(context, true);
//     //   return;
//     // }
//   }

//   final double width = MediaQuery.of(context).size.width;
//   final double height = MediaQuery.of(context).size.height;
//   return DialogButton(
//       margin: EdgeInsets.all(min(height, width) * 0.013),
//       // have round edges with same degree as Alert dialog
//       radius: const BorderRadius.all(Radius.circular(15)),
//       // set height and width of buttons so the shirt and name are fitting inside
//       height: width * 0.15,
//       width: width * 0.15,
//       color: color,
//       child: Center(
//         child: Column(
//           children: [
//             (icon != null) ? Icon(icon) : Container(),
//             Text(
//               buttonText,
//               style: TextStyle(color: Colors.white, fontSize: 20),
//             )
//           ],
//           mainAxisAlignment: MainAxisAlignment.center,
//         ),
//       ),
//       onPressed: () {
//         logAction();
//       });
// }
