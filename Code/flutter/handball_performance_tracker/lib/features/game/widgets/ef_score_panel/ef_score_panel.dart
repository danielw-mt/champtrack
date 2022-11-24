// import 'package:flutter/material.dart';
// import 'package:handball_performance_tracker/core/constants/colors.dart';
// import 'package:handball_performance_tracker/core/constants/positions.dart';
// import 'package:handball_performance_tracker/data/models/models.dart';
// import 'package:handball_performance_tracker/features/game/bloc/game_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:handball_performance_tracker/core/constants/fieldSizeParameter.dart' as fieldSizeParameter;
// import 'package:handball_performance_tracker/old-utils/player_helper.dart';
// import 'dart:math';
// import 'button_bar.dart';
// // TODO do we need this package?
// import 'package:rainbow_color/rainbow_color.dart';

// // Radius of round edges
// double menuRadius = 8.0;
// double buttonRadius = 8.0;
// // Width of padding between buttons
// double paddingWidth = 8.0;
// // height of button + line between buttons.
// double lineAndButtonHeight = fieldSizeParameter.fieldHeight / 7;
// // height of a button -> The full height should be used when 7 buttons are displayed.
// double buttonHeight = (fieldSizeParameter.fieldHeight - paddingWidth * 5.5) / 7;
// // width of popup
// double popupWidth = buttonHeight + 3 * paddingWidth;
// // width of efscore bar
// double scorebarWidth = popupWidth * 2.3 - 2 * paddingWidth;
// // width of a button in scorebar
// double scorebarButtonWidth = scorebarWidth;
// // track if plus button was pressed, so the adapted color of the pressed player on efscore bar does not change back to normal already.
// bool plusPressed = false;
// // Color of unpressed button
// Color buttonColor = Colors.white;
// // Color of pressed button
// Color pressedButtonColor = Colors.blue;
// double numberFontSize = 18;
// double nameFontSize = 14;
// // Spectrum for color coding of efscore
// var rb = Rainbow(spectrum: [
//   Color(0xffe99e9f),
//   Color(0xfff0d4b2),
//   Color(0xfff5fabf),
//   Color(0xffdef6c1),
//   Color(0xffbff2c4),
// ], rangeStart: -7.0, rangeEnd: 7.0);

// /*
// * Class that builds the column with buttons for permanent efscore bar.
// */
// class EfScoreBar extends StatelessWidget {
//   const EfScoreBar({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final gameBloc = context.watch<GameBloc>();
//     List<Container> buttons = [];
//     for (int i = 0; i < gameBloc.state.onFieldPlayers.length; i++) {
//       Container button = buildPlayerButton(context, i);
//       buttons.add(button);
//     }
//     return EfScoreButtonBar(
//       buttons: buttons,
//       width: scorebarWidth,
//       padWidth: 0.0,
//     );
//   }
// }

// // Opens a popup menu besides the Efscorebar.
// // @param buttons: Buttons to be displayed in popup
// // @param i: index of button to adapt the vertical position so the popup opens besides the pressed button.
// void showPopup(BuildContext context, List<Container> buttons, int i) {
//   final gameBloc = context.watch<GameBloc>();
//   int topPadding = i < 3 ? max((i - (buttons.length / 2).truncate()), 0) : max((i - (buttons.length / 2).round()), 0);
//   topPadding = buttons.length == 1 ? i : topPadding;
//   showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(

//                 // Make round borders.
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(menuRadius),
//                 ),

//                 // Set padding to all sides, so the popup has the needed size and position.
//                 insetPadding: EdgeInsets.only(
//                     // The dialog should appear on the right side of Efscore bar, so the padding on the left side need to be around width of scorebar.
//                     left: fieldSizeParameter.screenWidth - (fieldSizeParameter.fieldWidth + paddingWidth * 4 - scorebarWidth) - scorebarWidth,
//                     // As the dialog has also width = popupWidth, the right side padding is whole screenWidth-2*popupWidth
//                     right: fieldSizeParameter.fieldWidth + paddingWidth * 2 - scorebarWidth,
//                     // The dialog should open below the toolbar and other padding. Depending on the position (=index i) of the pressed button,
//                     // the top padding changes, so the dialog opens more or less besides the pressed button.
//                     top: fieldSizeParameter.toolbarHeight + fieldSizeParameter.paddingTop + topPadding * lineAndButtonHeight - paddingWidth * 6,
//                     // Bottom padding is determined similar to top padding.
//                     bottom: fieldSizeParameter.paddingBottom + max(((7 - i) - buttons.length), 0) * lineAndButtonHeight),
//                 // Set contentPadding to zero so there is no white padding around the bar.
//                 contentPadding: EdgeInsets.zero,
//                 content: Builder(
//                   builder: (context) {
//                     plusPressed = false;
//                     // show a ButtonBar inside the dialog with given buttons.
//                     return EfScoreButtonBar(
//                       buttons: buttons,
//                       width: scorebarWidth,
//                       padWidth: paddingWidth,
//                     );
//                   },
//                 ));
//           })
//       // TODO not sure when this comes into play but validate
//       // When closing check if Popup closes because the plus button was pressed (=> player is still selected on efscore bar)
//       // or because of other reasons (chose a player for substitution or just pressed anywhere in screen => player is unselected)
//       .then((_) => plusPressed ? null : gameBloc.add(RegisterClickOnPlayer(player: Player())));
// }


// getButton(Player player) {
//   PersistentController persistentController = Get.find<PersistentController>();
//   return GetBuilder<TempController>(
//     id: "player-bar-button",
//     builder: (tempController) {
//       // deal with penalized players here
//       if (tempController.isPlayerPenalized(player)) {
//         buttonColor = Colors.grey;
//       } else {
//         buttonColor = Colors.white;
//       }

//       return Row(
//         children: [
//           // Playernumber
//           Container(
//             // width is 1/5 of button width
//             width: scorebarButtonWidth / 5,
//             height: buttonHeight,
//             alignment: Alignment.center,

//             decoration: BoxDecoration(
//                 color: tempController.getPlayerToChange() == player ? pressedButtonColor : buttonColor,
//                 // make round edges
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(buttonRadius),
//                   topLeft: Radius.circular(buttonRadius),
//                 )),
//             child: Text(
//               (player.number).toString(),
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: numberFontSize,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.left,
//             ),
//           ),

//           // Playername
//           Expanded(
//             child: Container(
//               // width is 3/5 of button width
//               width: scorebarButtonWidth / 5 * 3,
//               height: buttonHeight,
//               alignment: Alignment.center,
//               color: tempController.getPlayerToChange() == player ? pressedButtonColor : buttonColor,
//               child: Text(
//                 player.lastName,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(color: Colors.black, fontSize: nameFontSize),
//                 textAlign: TextAlign.left,
//               ),
//             ),
//           ),

//           Container(
//             width: scorebarButtonWidth / 5,
//             height: buttonHeight,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//                 color: rb[player.efScore.score],
//                 // make round edges
//                 borderRadius: BorderRadius.only(
//                   bottomRight: Radius.circular(buttonRadius),
//                   topRight: Radius.circular(buttonRadius),
//                 )),
//             child: persistentController.playerEfScoreShouldDisplay(5, player)
//                 ? Text(
//                     player.efScore.score.toStringAsFixed(1),
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: nameFontSize,
//                     ),
//                     textAlign: TextAlign.left,
//                   )
//                 : Container(),
//           ),
//         ],
//       );
//     },
//   );
// }

// // Builds the plus button which is only present in popup.
// Container buildPlusButton(BuildContext context, int i) {
//   // Popup after clicking on plus at popup dialog.
//   // Shows all player which are not on field.
//   void popupAllPlayer(TempController tempController) {
//     List<Container> buttons = [];
//     for (int i in getNotOnFieldIndex()) {
//       Container button = buildPopupPlayerButton(context, i, tempController);
//       buttons.add(button);
//     }
//     showPopup(context, buttons, i);
//   }

//   return Container(
//     height: buttonHeight,
//     child: TextButton(
//       child: Icon(
//         Icons.add,
//         // Color of the +
//         color: Color.fromARGB(255, 97, 97, 97),
//         size: buttonHeight * 0.7,
//       ),
//       onPressed: () {
//         plusPressed = true;
//         Navigator.pop(context);
//         popupAllPlayer(tempController);
//       },
//       style: TextButton.styleFrom(
//         backgroundColor: buttonColor,
//         // make round button edges
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(buttonRadius)),
//         ),
//       ),
//     ),
//   );
// }
