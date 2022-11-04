import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'team_management_event.dart';
part 'team_management_state.dart';

class TeamManagementBloc extends Bloc<TeamManagementEvent, TeamManagementState> {
  TeamManagementBloc() : super(TeamManagementInitial()) {
    on<TeamManagementEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
