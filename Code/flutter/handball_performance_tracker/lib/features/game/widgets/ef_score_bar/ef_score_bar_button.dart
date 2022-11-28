import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/features/game/bloc/game_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/core/constants/field_size_parameters.dart' as fieldSizeParameter;
import 'package:handball_performance_tracker/features/game/widgets/ef_score_bar/ef_score_popup.dart';
import 'package:handball_performance_tracker/features/game/widgets/ef_score_bar/plus_button.dart';
import 'package:handball_performance_tracker/old-utils/player_helper.dart';
import 'dart:math';
import 'ef_score_bar.dart';
// TODO do we need this package?
// import 'package:rainbow_color/rainbow_color.dart';

class EfScoreBarButton extends StatelessWidget {
  Player player;
  bool isPopupButton;
  Player? substitutionTarget;
  EfScoreBarButton({super.key, required this.player, required this.isPopupButton, this.substitutionTarget});

  @override
  Widget build(BuildContext context) {
    final gameBloc = BlocProvider.of<GameBloc>(context);

    // deal with penalized players here
    if (gameBloc.state.penalizedPlayers.contains(player)) {
      buttonColor = Colors.grey;
    } else {
      buttonColor = Colors.white;
    }

    /// Method that returns true if there are already more than 5 actions for one player, giving the ef-score enough time to calibrate
    bool shouldEfScoreShow() {
      if (gameBloc.state.gameActions.where((GameAction action) => action.playerId == player.id).toList().length >= 5) {
        return true;
      } else {
        return false;
      }
    }

    return GestureDetector(
      child: Row(
        children: [
          // Playernumber
          Container(
            // width is 1/5 of button width
            width: scorebarButtonWidth / 5,
            height: buttonHeight,
            alignment: Alignment.center,

            decoration: BoxDecoration(
                color: gameBloc.state.substitutionTarget == player ? pressedButtonColor : buttonColor,
                // make round edges
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(buttonRadius),
                  topLeft: Radius.circular(buttonRadius),
                )),
            child: Text(
              (player.number).toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: numberFontSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),

          // Playername
          Expanded(
            child: Container(
              // width is 3/5 of button width
              width: scorebarButtonWidth / 5 * 3,
              height: buttonHeight,
              alignment: Alignment.center,
              color: gameBloc.state.substitutionTarget == player ? pressedButtonColor : buttonColor,
              child: Text(
                player.lastName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black, fontSize: nameFontSize),
                textAlign: TextAlign.left,
              ),
            ),
          ),

          Container(
            width: scorebarButtonWidth / 5,
            height: buttonHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: rb[player.efScore.score],
                // make round edges
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(buttonRadius),
                  topRight: Radius.circular(buttonRadius),
                )),
            child: shouldEfScoreShow()
                ? Text(
                    player.efScore.score.toStringAsFixed(1),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: nameFontSize,
                    ),
                    textAlign: TextAlign.left,
                  )
                : Container(),
          ),
        ],
      ),
      onTap: () {
        if (isPopupButton) {
          gameBloc.add(SubstitutePlayer(newPlayer: player, oldPlayer: substitutionTarget!));
        } else {
          // show popup
          List<Player> playersWithSamePosition = [];
          gameBloc.state.selectedTeam.players.forEach((Player playerFromTeam) {
            playerFromTeam.positions.forEach((String position) {
              if (player.positions.contains(position) && !gameBloc.state.onFieldPlayers.contains(playerFromTeam)) {
                playersWithSamePosition.add(playerFromTeam);
              }
            });
          });
          List<Widget> popupButtons = [];
          playersWithSamePosition.forEach((Player playerElement) {
            popupButtons.add(EfScoreBarButton(
              player: playerElement,
              isPopupButton: true,
              substitutionTarget: player,
            ));
          });
          popupButtons.add(PlusButton());
          int indexOfPlayer = gameBloc.state.onFieldPlayers.indexOf(player);
          showPlayerPopup(context, popupButtons, indexOfPlayer);
        }
      },
    );
  }
}
