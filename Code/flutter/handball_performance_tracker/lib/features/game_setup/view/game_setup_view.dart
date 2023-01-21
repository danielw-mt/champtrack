import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/dashboard/dashboard.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:handball_performance_tracker/features/game_setup/cubit/game_setup_cubit.dart';
import 'package:handball_performance_tracker/features/game_setup/widgets/widgets.dart';
import 'package:handball_performance_tracker/features/sidebar/sidebar.dart';

class GameSetupView extends StatelessWidget {
  GameSetupView({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Game Setup"),
            ),
            resizeToAvoidBottomInset: false,
            key: _scaffoldKey,
            drawer: SidebarView(),
            body: _buildGameSetupStep(context)));
  }

  Widget _buildGameSetupStep(BuildContext context) {
    final state = context.watch<GameSetupCubit>().state;

    if (state.currentStep == GameSetupStep.gameSettings) {
      return GameSettings();
    }
    if (state.currentStep == GameSetupStep.playerSelection) {
      return PlayerSelection();
    } else {
      return const Center(child: Text("This should not happen [Game Setup]"));
    }
  }
}
