import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:handball_performance_tracker/data/models/player_model.dart';

part 'team_management_event.dart';
part 'team_management_state.dart';

class TeamManagementBloc extends Bloc<TeamManagementEvent, TeamManagementState> {
  TeamManagementBloc() : super(TeamManagementState()) {
    on<TeamManagementEvent>((event, emit) {
      //emit(state.copyWith(status: TeamManagementStatus.loaded));
    });

    on<ChangeTabs>((event, emit) {
      emit(state.copyWith(status: TeamManagementStatus.loaded ,selectedTabIndex: event.tabIndex));
    });

    on<SelectTeam>(((event, emit) {
      emit(state.copyWith(status: TeamManagementStatus.loaded, selectedTeamIndex: event.index));
    }));

    on<DeleteTeam>(((event, emit) {
      emit(state.copyWith(status: TeamManagementStatus.loaded, selectedTeamIndex: event.index));
    }));

    on<PressAddTeam>(((event, emit) {
      print(event.addingTeam);
      emit(state.copyWith(status: TeamManagementStatus.loaded, addingTeam: event.addingTeam));
    }));

    on<PressAddPlayer>(((event, emit) {
      emit(state.copyWith(status: TeamManagementStatus.loaded, addingPlayer: event.addingPlayer));
    }));

    on<SelectTeamTyp>(((event, emit) {
      emit(state.copyWith(status: TeamManagementStatus.loaded, selectedTeamType: event.teamType));
    }));

    on<SelectTeamName>(((event, emit) {
      emit(state.copyWith(status: TeamManagementStatus.loaded, selectedTeamName: event.teamName));
    }));

    on<SelectViewField>(((event, emit) {
      emit(state.copyWith(status: TeamManagementStatus.loaded, viewField: event.viewField));
    }));

    on<SetSelectedPlayer>(((event, emit) {
      emit(state.copyWith(status: TeamManagementStatus.loaded, selectedPlayer: event.player));
    }));
  }
}
