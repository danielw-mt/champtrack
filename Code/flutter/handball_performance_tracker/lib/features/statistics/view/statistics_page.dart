import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/statistics/bloc/statistics_bloc.dart';
import 'package:handball_performance_tracker/features/statistics/view/view.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<StatisticsBloc>(context),
      child: StatisticsView(),
    );
  }
}
