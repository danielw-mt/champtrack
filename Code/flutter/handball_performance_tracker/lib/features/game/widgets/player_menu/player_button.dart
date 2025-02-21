import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/utils/icons.dart';
import 'package:handball_performance_tracker/core/constants/strings_game_screen.dart';
import 'dart:math';
// import '../../old-utils/feed_logic.dart';
import 'package:handball_performance_tracker/data/models/player_model.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerButton extends StatelessWidget {
  Player player;
  // if the button is on the second page of the player menu (new players to be substituted)
  bool isSubstitution;
  PlayerButton({super.key, required this.player, required this.isSubstitution});

  @override
  Widget build(BuildContext context) {
    final GameBloc gameBloc = context.read<GameBloc>();
    String buttonText = player.lastName;
    String buttonNumber = player.number.toString();

    Color buttonColor = Color.fromARGB(255, 180, 211, 236);
    // normal dialog button that has a shirt
    Column buttonContent = Column(
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
            // Center(
            //   child: Icon(
            //     MyFlutterApp.t_shirt,
            //   ),
            // ),
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
    // assist button
    if (gameBloc.state.workflowStep == WorkflowStep.assistSelection && player.id == gameBloc.state.gameActions.last.playerId) {
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
    }
    if (gameBloc.state.penalties.keys.contains(player)) {
      buttonColor = Colors.grey;
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
        gameBloc.add(RegisterPlayerSelection(player: player, isSubstitute: isSubstitution));
      },
    );
  }
}
