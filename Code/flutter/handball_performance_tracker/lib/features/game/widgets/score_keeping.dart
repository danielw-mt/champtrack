import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/core/constants/colors.dart';
import 'package:handball_performance_tracker/core/constants/strings_general.dart';
import 'package:handball_performance_tracker/core/constants/design_constants.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:handball_performance_tracker/data/models/models.dart';

class ScoreKeeping extends StatelessWidget {
  const ScoreKeeping({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameBloc gameBloc = context.watch<GameBloc>();
    return Container(
      margin: EdgeInsets.only(left: 30),
      decoration: BoxDecoration(
          color: buttonGreyColor,
          // set border so corners can be made round
          border: Border.all(
            color: buttonGreyColor,
          ),
          // make round edges
          borderRadius: BorderRadius.all(Radius.circular(MENU_RADIUS))),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name of own team
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                // nullable expression here
                gameBloc.state.selectedTeam == Team() ? 'TODO no team selected' : gameBloc.state.selectedTeam.name,
                textAlign: TextAlign.center,
              ),
            ),
            // Scores
            TextButton(
                onPressed: () {
                  callScoreKeeping(context);
                },
                child:
                    // Container with Scores
                    Container(
                        padding: const EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        color: Colors.white,
                        child: Text(
                          gameBloc.state.ownScore.toString() + " : " + gameBloc.state.opponentScore.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                        ))),
            // Name of opponent team
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(right: 5.0),
                child: Text(
                  gameBloc.state.opponent == "" ? 'TODO Unbekannt' : gameBloc.state.opponent,
                  textAlign: TextAlign.center,
                )),
          ],
        ),
      ),
    );
  }
}

void callScoreKeeping(BuildContext context) {
  double buttonHeight = MediaQuery.of(context).size.height * 0.1;
  final GameBloc gameBloc = context.read<GameBloc>();
  print("got here");
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: gameBloc,
          child: AlertDialog(
            scrollable: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MENU_RADIUS),
            ),
            content:
                // Column of "Edit score", horizontal line and score
                Column(
              children: [
                // upper row: Text "Edit score"
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    StringsGeneral.lEditScore,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                // horizontal line
                const Divider(
                  thickness: 2,
                  color: Colors.black,
                  height: 6,
                ),
                Text(""),

                IntrinsicHeight(
                  child: Row(
                    children: [
                      // Name of own team
                      Container(
                          margin: EdgeInsets.only(top: buttonHeight, bottom: buttonHeight),
                          decoration: BoxDecoration(
                            color: buttonGreyColor,
                            // set border so corners can be made round
                            border: Border.all(
                              color: buttonGreyColor,
                            ),
                            // make round edges
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(MENU_RADIUS), topLeft: Radius.circular(MENU_RADIUS)),
                          ),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            context.read<GameBloc>().state.selectedTeam == Team()
                                ? 'TODO no team selected'
                                : context.read<GameBloc>().state.selectedTeam.name,
                            textAlign: TextAlign.center,
                          )),
                      Column(
                        children: [
                          // Plus button of own team
                          SizedBox(
                            height: buttonHeight,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: buttonLightBlueColor,
                              ),
                              onPressed: () {
                                context.read<GameBloc>().add(ChangeScore(score: context.read<GameBloc>().state.ownScore + 1, isOwnScore: true));
                              },
                              child: Icon(Icons.add, size: 15, color: Colors.black),
                            ),
                          ),
                          // Container with Score
                          Container(
                              height: buttonHeight * 1.3,
                              width: buttonHeight,
                              margin: EdgeInsets.only(left: 5, right: 5),
                              padding: const EdgeInsets.all(10.0),
                              alignment: Alignment.center,
                              color: Colors.white,
                              child: TextField(
                                onChanged: (text) {
                                  // score cannot be negative or bigger than 2 digits for now
                                  if (text != "" && int.parse(text) > 0 && int.parse(text) < 100) {
                                    context.read<GameBloc>().add(ChangeScore(score: int.parse(text), isOwnScore: true));
                                  }
                                },
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(border: InputBorder.none, hintText: context.read<GameBloc>().state.ownScore.toString()),
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                                keyboardType: TextInputType.number,
                              )),
                          // Minus buttons of own team
                          SizedBox(
                            height: buttonHeight,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: buttonLightBlueColor,
                              ),
                              onPressed: () {
                                // score cannot be negative
                                if (context.read<GameBloc>().state.ownScore > 0) {
                                  context.read<GameBloc>().add(ChangeScore(score: context.read<GameBloc>().state.ownScore - 1, isOwnScore: true));
                                }
                              },
                              child: Icon(Icons.remove, size: 15, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      // Vertical line between score
                      VerticalDivider(
                        color: Colors.black,
                        endIndent: buttonHeight,
                        indent: buttonHeight,
                      ),
                      Column(children: [
                        // Plus button of opponent team
                        SizedBox(
                          height: buttonHeight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: buttonLightBlueColor,
                            ),
                            onPressed: () {
                              context.read<GameBloc>().add(ChangeScore(score: context.read<GameBloc>().state.ownScore + 1, isOwnScore: false));
                            },
                            child: Icon(Icons.add, size: 15, color: Colors.black),
                          ),
                        ),
                        // Container with Score

                        Container(
                            height: buttonHeight * 1.3,
                            width: buttonHeight,
                            margin: EdgeInsets.only(left: 5, right: 5),
                            padding: const EdgeInsets.all(10.0),
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: TextField(
                              onChanged: (text) {
                                // score cannot be negative or bigger than 2 digits for now
                                if (text != "" && int.parse(text) > 0 && int.parse(text) < 100) {
                                  context.read<GameBloc>().add(ChangeScore(score: int.parse(text), isOwnScore: false));
                                }
                              },
                              textAlign: TextAlign.center,
                              decoration:
                                  InputDecoration(border: InputBorder.none, hintText: context.read<GameBloc>().state.opponentScore.toString()),
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                              keyboardType: TextInputType.number,
                            )),
                        // minus button of opponent team
                        SizedBox(
                          height: buttonHeight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: buttonLightBlueColor,
                            ),
                            onPressed: () {
                              // score cannot be negative
                              if (context.read<GameBloc>().state.opponentScore > 0) {
                                context.read<GameBloc>().add(ChangeScore(score: context.read<GameBloc>().state.opponentScore - 1, isOwnScore: false));
                              }
                            },
                            child: Icon(Icons.remove, size: 15, color: Colors.black),
                          ),
                        )
                      ]),

                      // Name of opponent team
                      Container(
                          margin: EdgeInsets.only(top: buttonHeight, bottom: buttonHeight),
                          decoration: BoxDecoration(
                              color: buttonGreyColor,
                              // set border so corners can be made round
                              border: Border.all(
                                color: buttonGreyColor,
                              ),
                              // make round edges
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(MENU_RADIUS), topRight: Radius.circular(MENU_RADIUS))),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            StringsGeneral.lOpponent,
                            textAlign: TextAlign.center,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
