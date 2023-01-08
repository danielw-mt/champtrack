import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:handball_performance_tracker/data/models/models.dart';

class ScoreKeeping extends StatelessWidget {
  const ScoreKeeping({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameBloc gameBloc = context.watch<GameBloc>();
    void callScoreKeeping(BuildContext context) {
      double buttonHeight = MediaQuery.of(context).size.height * 0.1;

      showDialog(
          context: context,
          builder: (BuildContext context) {
            TextEditingController _ownScoreController = TextEditingController(text: gameBloc.state.ownScore.toString());
            TextEditingController _opponentScoreController = TextEditingController(text: gameBloc.state.opponentScore.toString());
            return BlocListener<GameBloc, GameState>(
              bloc: gameBloc,
              listener: (context, state) => {
                _ownScoreController.text = state.ownScore.toString(),
                _opponentScoreController.text = state.opponentScore.toString(),
              },
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
                                gameBloc.state.selectedTeam == Team() ? 'TODO no team selected' : gameBloc.state.selectedTeam.name,
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
                                    gameBloc.add(ChangeScore(score: gameBloc.state.ownScore + 1, isOwnScore: true));
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
                                    controller: _ownScoreController,
                                    onEditingComplete: () {
                                      // score cannot be negative or bigger than 2 digits for now
                                      if (_ownScoreController.text != "" &&
                                          int.parse(_ownScoreController.text) > 0 &&
                                          int.parse(_ownScoreController.text) < 100) {
                                        gameBloc.add(ChangeScore(score: int.parse(_ownScoreController.text), isOwnScore: true));
                                      } else {
                                        _ownScoreController.text = gameBloc.state.ownScore.toString();
                                      }
                                    },
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(border: InputBorder.none, hintText: gameBloc.state.ownScore.toString()),
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
                                    if (gameBloc.state.ownScore > 0) {
                                      gameBloc.add(ChangeScore(score: gameBloc.state.ownScore - 1, isOwnScore: true));
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
                                  gameBloc.add(ChangeScore(score: gameBloc.state.opponentScore + 1, isOwnScore: false));
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
                                  controller: _opponentScoreController,
                                  onEditingComplete: () {
                                    // score cannot be negative or bigger than 2 digits for now
                                    if (_opponentScoreController.text != "" &&
                                        int.parse(_opponentScoreController.text) > 0 &&
                                        int.parse(_opponentScoreController.text) < 100) {
                                      gameBloc.add(ChangeScore(score: int.parse(_opponentScoreController.text), isOwnScore: false));
                                    } else {
                                      _opponentScoreController.text = gameBloc.state.opponentScore.toString();
                                    }
                                  },
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(border: InputBorder.none, hintText: gameBloc.state.opponentScore.toString()),
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
                                  if (gameBloc.state.opponentScore > 0) {
                                    gameBloc.add(ChangeScore(score: gameBloc.state.opponentScore - 1, isOwnScore: false));
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
