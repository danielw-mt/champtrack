

class TeamStatistics {
  Map<String, dynamic> teamStats = {};
  Map<String, int> actionCounts = {};
  Map<String, List<int>> actionSeries = {};
  int startTime = 0;
  int stopTime = 0;
  List<List<double>> quotas = [
    [0, 0],
    [0, 0],
    [0, 0],
    [0, 0]
  ];
  List<double> efScoreSeries = [];
  List<int> timeStamps = [];

  TeamStatistics({
    this.teamStats = const {},
    this.actionCounts = const {},
    this.actionSeries = const {},
    this.startTime = 0,
    this.stopTime = 0,
    this.quotas = const [
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0]
    ],
    this.efScoreSeries = const [],
    this.timeStamps = const [],
  });

  @override
  String toString() {
    // return the string representation of the object
    return 'TeamStatistics: { teamStats: $teamStats, +\n actionCountsStats: $actionCounts, +\n actionSeriesStats: $actionSeries, +\n startTimeStats: $startTime, +\n stopTimeStats: $stopTime, +\n quotasStats: $quotas, +\n efScoreSeriesStats: $efScoreSeries, +\n timeStampsStats: $timeStamps }';
  }


}