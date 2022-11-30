import 'dart:js';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/data/repositories/auth_repository.dart';
import 'package:handball_performance_tracker/data/repositories/game_repository.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  GameFirebaseRepository gameRepository;

  StatisticsBloc({required GameFirebaseRepository this.gameRepository}) : super(StatisticsState()) {
    on<StatisticsEvent>((event, emit) {
    });
    on<ChangeTabs>((event, emit) {
      emit(state.copyWith(selectedStatScreenIndex: event.tabIndex));
    });

    on<SelectTeam>((event, emit) {
      emit(state.copyWith(selectedTeam: event.team));
    });

    on<InitStatistics>((event, emit) async {
      try {
        // emit(state.copyWith(status: GlobalStatus.loading));
        // List<Player> fetchedPlayers = await PlayerFirebaseRepository().fetchPlayers();
        // List<Team> fetchedTeams = await TeamFirebaseRepository().fetchTeams(allPlayers: fetchedPlayers);
        List<Game> fetchedGames = gameRepository.games;

        // TODO statistic engine here in state variable
         
        emit(state.copyWith(allGames: fetchedGames));
      } catch (e) {
        // developer.log('Failure loading teams or players ' + e.toString(), name: this.runtimeType.toString(), error: e);
        // emit(state.copyWith(status: GlobalStatus.failure));
      }
      //emit(state.copyWith());
    });
  }
}
