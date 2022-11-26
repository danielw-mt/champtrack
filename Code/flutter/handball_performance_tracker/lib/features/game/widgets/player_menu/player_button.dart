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

class PlayerButton extends StatelessWidget {
  Player player;
  bool isSubstitute;
  PlayerButton({super.key, required this.player, required this.isSubstitute});

  @override
  Widget build(BuildContext context) {
    final GameBloc gameBloc = context.read<GameBloc>();
    String buttonText = player.lastName;
    String buttonNumber = player.number.toString();

    Color buttonColor = Color(0);
    Column buttonContent = Column();
    // assist button
    if (gameBloc.state.assistAvailable && player.id == gameBloc.state.gameActions.last.playerId) {
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
                  // make shirt smaller if there are more than 7 player displayed in the substitution grid
                  //   size: (isSubstitute || gameBloc.state.selectedTeam.players.length > 14)
                  //       ? (MediaQuery.of(context).size.width * 0.11)
                  //       : (MediaQuery.of(context).size.width * 0.11 / (gameBloc.state.selectedTeam.players.length - 7) * 7),
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
        gameBloc.add(RegisterPlayerSelection(player: player, isSubstitute: isSubstitute));
      },
    );
  }
}
