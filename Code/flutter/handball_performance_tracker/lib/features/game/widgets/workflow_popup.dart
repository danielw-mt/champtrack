import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/game/game.dart';

void openWorkflowPopup(BuildContext higherContext, GameBloc gameBloc) {
  print("opening workflow popup");
  Widget provideWorkflowMenuContent() {
    print("providing content");
    WorkflowStep lastStep = higherContext.read<GameBloc>().state.workflowStep;
    switch (lastStep) {
      case WorkflowStep.actionMenuDefense:
        return ActionMenu(
          style: ActionMenuStyle.defense,
        );
      case WorkflowStep.actionMenuGoalKeeper:
        return ActionMenu(
          style: ActionMenuStyle.goalkeeper,
        );
      case WorkflowStep.actionMenuOffense:
        return ActionMenu(
          style: ActionMenuStyle.offense,
        );
      case WorkflowStep.playerSelection:
        print('player selection');
        return PlayerMenu(style: PlayerMenuStyle.standard);
      case WorkflowStep.sevenMeterExecutorSelection:
        return PlayerMenu(style: PlayerMenuStyle.sevenMeterExecutor);
      case WorkflowStep.sevenMeterFoulerSelection:
        return PlayerMenu(style: PlayerMenuStyle.sevenMeterFouler);
      case WorkflowStep.sevenMeterScorerSelection:
        return PlayerMenu(style: PlayerMenuStyle.sevenMeterScorer);
      case WorkflowStep.substitutionTargetSelection:
        return PlayerMenu(style: PlayerMenuStyle.substitutionTarget);
      case WorkflowStep.goalkeeperSelection:
        return PlayerMenu(style: PlayerMenuStyle.goalKeeperSelection);
      case WorkflowStep.assistSelection:
        return PlayerMenu(style: PlayerMenuStyle.assist);
      case WorkflowStep.forceClose:
        return Container();
      default:
        return Container();
    }
  }

  showDialog(
      context: higherContext,
      builder: (BuildContext bcontext) {
        return BlocProvider.value(
            value: gameBloc,
            child: AlertDialog(
                scrollable: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MENU_RADIUS),
                ),
                content: BlocBuilder<GameBloc, GameState>(
                    bloc: gameBloc,
                    builder: (context, state) {
                      if (state.workflowStep == WorkflowStep.forceClose) {
                        Navigator.pop(bcontext);
                        return Visibility(
                          child: Container(),
                          visible: false,
                        );
                      }
                      return Container(
                          width: MediaQuery.of(higherContext).size.width * 0.72,
                          height: MediaQuery.of(higherContext).size.height * 0.7,
                          child: provideWorkflowMenuContent());
                    })));
      }).then((value) => gameBloc.state.workflowStep = WorkflowStep.closed);
}
