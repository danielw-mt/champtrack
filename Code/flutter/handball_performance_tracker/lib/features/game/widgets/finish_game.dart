import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:handball_performance_tracker/features/dashboard/dashboard.dart';

class FinishGameButton extends StatelessWidget {
  const FinishGameButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameBloc = context.watch<GameBloc>();
    final GlobalBloc globalBloc = context.watch<GlobalBloc>();
    return Container(
      margin: EdgeInsets.only(right: 3),
      child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: buttonDarkBlueColor,
            primary: Colors.black,
          ),
          onPressed: () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text(StringsGameScreen.lStopGame),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, StringsGameSettings.lCancelButton),
                    child: Text(
                      StringsGameSettings.lCancelButton,
                      style: TextStyle(
                        color: buttonDarkBlueColor,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      gameBloc.add(FinishGame());
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardView()));
                      gameBloc.add(ResetGame());
                      globalBloc.add(ResetPlayerScores());
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: buttonDarkBlueColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          child: Row(
            children: [
              Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              Text(
                StringsGameScreen.lStopGame,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          )),
    );
  }
}
