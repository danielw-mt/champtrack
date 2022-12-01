import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'action_panel.dart';

void callActionMenu(BuildContext context) async {
  final GameBloc gameBloc = context.read<GameBloc>();
  String actionContext = "";

  // when we are attacking and we clicked on the enemy goal then context is other goalkeeper
  if (!gameBloc.state.lastClickedLocation.isEmpty) if (gameBloc.state.lastClickedLocation[0] == goalTag && gameBloc.state.attacking) {
    actionContext = actionContextOtherGoalkeeper;
  }
  // when defending and clicking on our goal context is our goalkeeper
  if (!gameBloc.state.lastClickedLocation.isEmpty) if (gameBloc.state.lastClickedLocation[0] == goalTag && !gameBloc.state.attacking) {
    actionContext = actionContextGoalkeeper;
  }
  // context for all action in offensive half
  if (gameBloc.state.attacking) {
    actionContext = actionContextAttack;
  }
  // context for all actions in defensive half
  if (!gameBloc.state.attacking) {
    actionContext = actionContextDefense;
  }

  // if game is not running give a warning
  if (gameBloc.state.status != GameStatus.running) {
    showDialog(
        context: context,
        builder: (BuildContext bcontext) {
          return AlertDialog(
              scrollable: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MENU_RADIUS),
              ),
              content: CustomAlertMessageWidget(StringsGameScreen.lGameStartErrorMessage));
        }).then((value) {});
    return;
  }

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
              content: Container(
                  width: MediaQuery.of(context).size.width * 0.72,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    Expanded(
                      child: ActionPanel(
                        actionContext: actionContext,
                      ),
                    )
                  ] // Column of "Player", horizontal line and Button-Row
                      ))),
        );
      }).then((value) {});
}
