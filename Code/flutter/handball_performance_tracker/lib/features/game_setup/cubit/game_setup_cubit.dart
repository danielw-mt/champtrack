import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/data/repositories/repositories.dart';
import 'dart:developer' as developer;

part 'game_setup_state.dart';

class GameSetupCubit extends Cubit<GameSetupState> {
  GameSetupCubit() : super(GameSetupState());

  void setSettings(
      {required String opponent,
      required String location,
      required DateTime date,
      required int selectedTeamIndex,
      required bool isHomeGame,
      required bool attackIsLeft}) {
        print("setSettings");
    emit(state.copyWith(
      currentStep: GameSetupStep.playerSelection,
      opponent: opponent,
      location: location,
      date: date,
      selectedTeamIndex: selectedTeamIndex,
      isHomeGame: isHomeGame,
      attackIsLeft: attackIsLeft,
      onFieldPlayers: []
    ));
  }

  void selectTeam(int selectedTeamIndex) {
    emit(state.copyWith(selectedTeamIndex: selectedTeamIndex));
  }

  void goToSettings() {
    print("go to settings");
    emit(state.copyWith(
      currentStep: GameSetupStep.gameSettings,
    ));
  }

  void setOnFieldPlayers(List<Player> onFieldPlayers) {
    emit(state.copyWith(
      onFieldPlayers: onFieldPlayers,
    ));
  }
}
