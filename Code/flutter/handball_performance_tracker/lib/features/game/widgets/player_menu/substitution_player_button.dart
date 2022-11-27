import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/old-utils/icons.dart';
import 'dart:math';
import 'package:handball_performance_tracker/data/models/player_model.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubstitutionPlayerButton extends StatelessWidget {
  Player substitutionPlayer;
  Player toBeSubstitutedPlayer;
  // if the button is on the second page of the player menu (new players to be substituted)
  SubstitutionPlayerButton({super.key, required this.substitutionPlayer, required this.toBeSubstitutedPlayer});

  @override
  Widget build(BuildContext context) {
    final GameBloc gameBloc = context.read<GameBloc>();
    String buttonText = substitutionPlayer.lastName;
    String buttonNumber = substitutionPlayer.number.toString();

    Color buttonColor = Color(0);
    Column buttonContent = Column();

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
        gameBloc.add(SubstitutePlayer(toBeSubstitutedPlayer: toBeSubstitutedPlayer, substitutionPlayer: substitutionPlayer));
      },
    );
  }
}
