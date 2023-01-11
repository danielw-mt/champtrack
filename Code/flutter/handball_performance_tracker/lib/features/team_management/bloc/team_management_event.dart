part of 'team_management_bloc.dart';

abstract class TeamManagementEvent extends Equatable {
  const TeamManagementEvent();

  @override
  List<Object> get props => [];
}

class ChangeTabs extends TeamManagementEvent{
  final int tabIndex;

  ChangeTabs({required this.tabIndex});
}

class SelectTeam extends TeamManagementEvent{
  final int index;

  SelectTeam({required this.index});
}

class DeleteTeam extends TeamManagementEvent {
  final int index;

  DeleteTeam({required this.index});
}