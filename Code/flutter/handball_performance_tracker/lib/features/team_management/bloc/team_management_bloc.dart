import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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
  }
}
