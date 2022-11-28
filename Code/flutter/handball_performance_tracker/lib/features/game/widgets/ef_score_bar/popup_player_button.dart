// import 'package:flutter/material.dart';
// import 'package:handball_performance_tracker/core/constants/colors.dart';
// import 'package:handball_performance_tracker/core/constants/positions.dart';
// import 'package:handball_performance_tracker/data/models/models.dart';
// import 'package:handball_performance_tracker/features/game/bloc/game_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:handball_performance_tracker/core/constants/field_size_parameters.dart' as fieldSizeParameter;
// import 'package:handball_performance_tracker/old-utils/player_helper.dart';
// import 'dart:math';
// import 'player_bar.dart';
// // TODO do we need this package?
// import 'package:rainbow_color/rainbow_color.dart';


// /// builds a single button which represents a player on popup menu.
// /// @param i: Index of player that is represented by the button of tempController.getSelectedPlayersFromSelectedTeam().
// /// @return Container with TextButton representing the player.
// ///         The index of player which button was pressed in tempController.getOnFieldPlayers() is changed with index of player
// ///           with index i in tempController.getSelectedPlayersFromSelectedTeam().
// class PopupPlayerButton extends StatelessWidget {
//   Player playerToBeSubstituted;
//   PopupPlayerButton({super.key, required this.playerToBeSubstituted});

//   @override
//   Widget build(BuildContext context) {
//     final gameBloc = context.watch<GameBloc>();
//     // Changes player which was pressed in the efscore bar (tempController.getPlayerToChange)
//     // with a player which was pressed in a popup dialog.
//     void changePlayer() {
//       // get index of player which was pressed in efscore bar in tempController.getOnFieldPlayers()
//       int k = gameBloc.state.onFieldPlayers.indexOf();
//       // Change the player which was pressed in efscore bar in tempController.getOnFieldPlayers()
//       // to the player which was pressed in popup dialog.
//       tempController.setOnFieldPlayer(k, tempController.getPlayersFromSelectedTeam()[i], currentGame);
//       // Update player bar players
//       int l = tempController.getPlayersFromSelectedTeam().indexOf(tempController.getPlayerToChange());
//       int indexToChange = tempController.getPlayerBarPlayers().indexOf(l);
//       tempController.changePlayerBarPlayers(indexToChange, i);
//     }

//     // build button for popup
//     return Container(
//       decoration: BoxDecoration(
//           // make round edges
//           borderRadius: BorderRadius.all(Radius.circular(buttonRadius))),
//       height: buttonHeight,
//       width: scorebarButtonWidth,
//       child: Stack(
//         children: [
//           getButton(tempController.getPlayersFromSelectedTeam()[i]),
//           SizedBox(
//             height: buttonHeight,
//             width: scorebarButtonWidth,
//             child: TextButton(
//               child: const Text(""),
//               onPressed: () {
//                 changePlayer();
//                 Navigator.pop(context, true);
//                 tempController.setPlayerToChange(Player());
//               },
//               style: TextButton.styleFrom(
//                 // Color of pressed player changes on efscore bar.
//                 backgroundColor: Colors.transparent,
//                 // make round button edges
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(buttonRadius),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
