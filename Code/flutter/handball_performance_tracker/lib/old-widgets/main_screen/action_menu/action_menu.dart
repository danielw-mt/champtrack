// import 'package:flutter/material.dart';
// import '../../../../../old-widgets/helper_screen/alert_message_widget.dart';
// import '../../../../../old-widgets/main_screen/ef_score_bar.dart';
// import 'package:stop_watch_timer/stop_watch_timer.dart';
// import '../../../core/constants/stringsGameScreen.dart';
// import '../../../oldcontrollers/persistent_controller.dart';
// import '../../../oldcontrollers/temp_controller.dart';
// import 'package:get/get.dart';
// import '../../../core/constants/game_actions.dart';
// import 'package:logger/logger.dart';
// import 'dialog_button_menu.dart';

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

// void callActionMenu(BuildContext context) {
//   logger.d("Calling action menu");
//   final PersistentController persController = Get.find<PersistentController>();

//   String actionState = determineActionState();

//   // do nothing if goal of others was clicked
//   if (actionState == actionContextOtherGoalkeeper) {
//     return;
//   }
//   StopWatchTimer stopWatchTimer = persController.getCurrentGame().stopWatchTimer;
//   // if game is not running give a warning
//   if (stopWatchTimer.rawTime.value == 0) {
//     showDialog(
//         context: context,
//         builder: (BuildContext bcontext) {
//           return AlertDialog(
//               scrollable: true,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(menuRadius),
//               ),
//               content: CustomAlertMessageWidget(StringsGameScreen.lGameStartErrorMessage));
//         });
//     return;
//   }

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
//                 width: MediaQuery.of(context).size.width * 0.72,
//                 height: MediaQuery.of(context).size.height * 0.7,
//                 child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
//                   Expanded(
//                     child: DialogButtonMenu(
//                       actionContext: actionState,
//                     ),
//                   )
//                 ] // Column of "Player", horizontal line and Button-Row
//                     )));
//       });
// }

// /// determine if action was attack, defense, goalkeeper
// String determineActionState() {
//   logger.d("Determining which actions should be displayed...");
//   final TempController tempController = Get.find<TempController>();
//   // decide whether attack or defense actions should be displayed depending
//   //on what side the team goals is and whether they are attacking or defending
//   String actionContext = actionContextDefense;
//   bool attackIsLeft = tempController.getAttackIsLeft();
//   bool fieldIsLeft = tempController.getFieldIsLeft();
//   // when our goal is to the right (= attackIsLeft) and the field is left
//   //display attack options
//   if (tempController.getLastLocation()[0] == goalTag) {
//     actionContext = actionContextGoalkeeper;
//     if (attackIsLeft && fieldIsLeft) {
//       actionContext = actionContextOtherGoalkeeper;
//       // when our goal is to the left (=attack is right) and the field is to the
//       //right display attack options
//     } else if (attackIsLeft == false && fieldIsLeft == false) {
//       actionContext = actionContextOtherGoalkeeper;
//     }
//   } else {
//     if (attackIsLeft && fieldIsLeft) {
//       actionContext = actionContextAttack;
//       // when our goal is to the left (=attack is right) and the field is to the
//       //right display attack options
//     } else if (attackIsLeft == false && fieldIsLeft == false) {
//       actionContext = actionContextAttack;
//     }
//   }
//   logger.d("Actions should be displayed: $actionContext");
//   return actionContext;
// }
