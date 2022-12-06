import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';
import 'package:handball_performance_tracker/data/models/models.dart';

// Menu for deciding who will execute the seven meter
void callAllPlayersMenu(BuildContext context, Player substitutionTarget) {
  final GameBloc gameBloc = context.read<GameBloc>();
  showDialog(
      context: context,
      builder: (BuildContext bcontext) {
        List<EfScoreBarButton> buildChildren() {
          List<EfScoreBarButton> children = [];
          gameBloc.state.selectedTeam.players.forEach((Player player) {
            if (player != substitutionTarget) {
              children.add(EfScoreBarButton(
                player: player,
                isPopupButton: true,
                substitutionTarget: substitutionTarget,
              ));
            }
          });
          return children;
        }

        return BlocProvider.value(
            value: gameBloc,
            child: AlertDialog(
                scrollable: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MENU_RADIUS),
                ),
                // alert contains a list of DialogButton objects
                content: Column(
                  children: [
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
                          child: Text(
                            StringsGameScreen.lChooseSubstitute,
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: GridView.count(
                          padding: EdgeInsets.all(PADDING_WIDTH),
                          shrinkWrap: true,
                          // 4 items max per row
                          crossAxisCount: 4,
                          children: buildChildren()),
                    )
                  ],
                )));
      });
}
