part of 'statistics_bloc.dart';

abstract class StatisticsEvent extends Equatable {
  const StatisticsEvent();

  @override
  List<Object> get props => [];
}

class ChangeTabs extends StatisticsEvent {
  final int tabIndex;

  ChangeTabs({required this.tabIndex});
}

class SelectTeam extends StatisticsEvent {
  final Team team;

  SelectTeam({required this.team});
}
