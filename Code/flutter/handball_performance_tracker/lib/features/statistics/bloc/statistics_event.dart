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

class PieChartView extends StatisticsEvent {
  final bool pieChartView;

  PieChartView({required this.pieChartView});
}

class SelectTeamPerformanceParameter extends StatisticsEvent {
  final String parameter;

  SelectTeamPerformanceParameter({required this.parameter});
}

class SelectPerformanceParameter extends StatisticsEvent {
  final String parameter;
  // if true change selectedTeamPerformanceParameter, else change selectedPlayerPerformanceParameter
  final bool teamParameter; 

  SelectPerformanceParameter({required this.parameter, required this.teamParameter});
}

class SelectTeam extends StatisticsEvent {
  final Team team;

  SelectTeam({required this.team});
}

class SelectGame extends StatisticsEvent {
  final Game game;

  SelectGame({required this.game});
}

class SelectPlayer extends StatisticsEvent {
  final Player player;

  SelectPlayer({required this.player});
}

class SwitchField extends StatisticsEvent {
  final bool switchField;

  SwitchField({required this.switchField});
}

class SelectHeatmapParameter extends StatisticsEvent {
  final String parameter;

  SelectHeatmapParameter({required this.parameter});
}

class InitStatistics extends StatisticsEvent {
  //final Team team = context.read<GlobalBloc>().state.selectedTeam;

  InitStatistics();
}
