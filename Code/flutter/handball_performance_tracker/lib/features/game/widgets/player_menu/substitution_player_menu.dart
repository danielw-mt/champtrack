import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:handball_performance_tracker/data/models/player_model.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'substitution_player_button.dart';

/// A player menu that gets opened to offer onFieldPlayer that can be substituted after a player not on field has been selected for an action
void callSubstitutionPlayerMenu(BuildContext context) {
  final GameBloc gameBloc = context.read<GameBloc>();
  PageController pageController = PageController();

  showDialog(
          context: context,
          builder: (BuildContext bcontext) {
            return BlocProvider.value(
              value: gameBloc,
              child: AlertDialog(
                scrollable: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MENU_RADIUS),
                ),
                // alert contains a list of DialogButton objects
                content:
                    // Column of "Player", horizontal line and Button-Row
                    Column(
                  children: [
                    // upper row: "Player" Text on left and "Assist" will pop up on right after a goal.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            StringsGeneral.lPlayer,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          // Change from "" to "Assist" after a goal.
                          child: Text(
                            StringsGameScreen.lChooseSubstitutedPlayer,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Colors.purple,
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
                    // Substitute player text
                    Text(
                      StringsGameScreen.lSubstitute1 +
                          gameBloc.state.substitutionTarget.firstName +
                          " " +
                          gameBloc.state.substitutionTarget.lastName +
                          " " +
                          StringsGameScreen.lSubstitute2,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    GridView.count(
                      // 4 items max per row
                      crossAxisCount: 4,
                      padding: const EdgeInsets.all(20),
                      children: gameBloc.state.onFieldPlayers
                          .map((Player player) => SubstitutionPlayerButton(
                                substitutionPlayer: gameBloc.state.substitutionTarget,
                                toBeSubstitutedPlayer: player,
                              ))
                          .toList(),
                    )
                  ],
                ),
              ),
            );
          })
      // When closing set player menu text to ""
      // if just pressed anywhere in screen)
      .then((_) {
    gameBloc.add(ChangeMenuStatus(menuStatus: MenuStatus.closed));
  });
}
