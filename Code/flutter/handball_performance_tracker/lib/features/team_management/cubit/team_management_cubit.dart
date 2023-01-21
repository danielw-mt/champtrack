import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/data/repositories/repositories.dart';
import 'dart:developer' as developer;

part 'team_management_state.dart';

class TeamManagementCubit extends Cubit<TeamManagementState> {
  TeamManagementCubit() : super(TeamManagementState());


  changeTab(TeamManagementTab tab) {
    emit(state.copyWith(currentTab: tab));
  }

  selectTeam(int index) {
    emit(state.copyWith(selectedTeamIndex: index));
  }
}
