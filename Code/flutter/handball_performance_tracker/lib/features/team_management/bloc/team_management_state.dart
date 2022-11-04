part of 'team_management_bloc.dart';

abstract class TeamManagementState extends Equatable {
  const TeamManagementState();
  
  @override
  List<Object> get props => [];
}

class TeamManagementInitial extends TeamManagementState {}
