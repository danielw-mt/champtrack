import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/statistics/bloc/statistics_bloc.dart';
import 'package:handball_performance_tracker/features/statistics/view/view.dart';

import 'package:handball_performance_tracker/features/team_management/team_management.dart';
import 'package:handball_performance_tracker/data/repositories/repositories.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    //final statisticsBloc = BlocProvider.of<StatisticsBloc>(context);
    return BlocProvider.value(
      // create: (_) => StatisticsBloc(),
      value: BlocProvider.of<StatisticsBloc>(context),
      child: StatisticsView(),
    );
  }
}
