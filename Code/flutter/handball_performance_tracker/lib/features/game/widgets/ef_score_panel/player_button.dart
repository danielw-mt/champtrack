// import 'package:flutter/material.dart';
// import 'package:handball_performance_tracker/core/core.dart';
// import 'package:handball_performance_tracker/data/models/models.dart';
// import 'package:handball_performance_tracker/features/game/bloc/game_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:handball_performance_tracker/core/constants/field_size_parameters.dart' as fieldSizeParameter;
// import 'dart:math';
// import 'player_button_bar.dart';
// import 'player_helper.dart';

// /// Builds a single button which represents a player on efscore player bar
// /// @param i: Index of player that is represented in playerBarPlayers
// /// @return Container with TextButton representing the player.
// ///         On pressing the button a new popup with possible substitute player pops up.
// class PlayerButton extends StatelessWidget {
//   Player player = Player();
//   PlayerButton({super.key, player}) {
//     this.player = player;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final gameBloc = context.watch<GameBloc>();

//     // Get player which have at least one of the given positions.
//     List<Player> playerWithSamePosition(List<String> positions) {
//       List<Player> substitutePlayer = [];
//       // if we are on defense side, show defense specialists first
//       if (gameBloc.state.attacking == false)
//         // old code to determine offense / defense
//         // if ((tempController.getFieldIsLeft() && !tempController.getAttackIsLeft()) ||
//         //     (!tempController.getFieldIsLeft() && tempController.getAttackIsLeft()))
//         for (int k in getNotOnFieldIndex(gameBloc.state.selectedTeam, gameBloc.state.onFieldPlayers)) {
//           Player player = gameBloc.state.selectedTeam.players[k];
//           if (player.positions.contains(defenseSpecialist)) {
//             substitutePlayer.add(player);
//           }
//         }
//       // add other players on same position
//       for (int k in getNotOnFieldIndex(gameBloc.state.selectedTeam, gameBloc.state.onFieldPlayers)) {
//         for (String position in positions) {
//           if (position != defenseSpecialist) {
//             Player player = gameBloc.state.selectedTeam.players[k];
//             if (player.positions.contains(position) && !substitutePlayer.contains(player)) {
//               substitutePlayer.add(player);
//               break;
//             }
//           }
//         }
//       }
//       return substitutePlayer;
//     }

//     // Popup after clicking on one player at efscore bar.
//     void popupSubstitutePlayer() {
//       // Save pressed player, so this player can be changed in the next step.

//       // Build buttons out of players that are not on field and have the same position as pressed player.
//       List<Player> playersWithSamePosition = gameBloc.state.selectedTeam.players.where((Player playerElement) {
//         for (String position in this.player.positions) {
//           if (playerElement.positions.contains(position) && !gameBloc.state.onFieldPlayers.contains(playerElement)) {
//             return true;
//           }
//           return false;
//         }
//         // this case should never happen
//         return false;
//       }).toList();
//       List<Container> buttons = [];

//       for (int k = 0; k < playersWithSamePosition.length; k++) {
//         int l = gameBloc.state.selectedTeam.players.indexOf(playersWithSamePosition[k]);
//         Container button = buildPopupPlayerButton(context, l);
//         buttons.add(button);
//       }
//       // Add the button with the plus here.
//       buttons.add(buildPlusButton(context, i, tempController));

//       // Open popup dialog.
//       // int i: Index of player in playerbar
//       showPopup(context, buttons, i);
//     }

//     // build buttons for permanent bar with efscore
//     return Container(
//       decoration: BoxDecoration(

//           // make round edges
//           borderRadius: BorderRadius.all(Radius.circular(buttonRadius))),
//       height: buttonHeight,
//       child: Stack(
//         children: [
//           getButton(
//             tempController.getPlayersFromSelectedTeam()[tempController.getPlayerBarPlayers()[i]],
//           ),
//           SizedBox(
//             height: buttonHeight,
//             width: scorebarButtonWidth,
//             child: TextButton(
//               child: const Text(""),
//               onPressed: () {
//                 // check whether the player is penalized. If yes, cancel the penalty
//                 // only open the popup when there is no penalty
//                 Player player = tempController.getPlayersFromSelectedTeam()[tempController.getPlayerBarPlayers()[i]];
//                 if (tempController.isPlayerPenalized(player)) {
//                   tempController.removePenalizedPlayer(player);
//                 } else {
//                   popupSubstitutePlayer(tempController);
//                 }
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

