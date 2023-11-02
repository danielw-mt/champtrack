import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/dashboard/dashboard.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:handball_performance_tracker/features/authentication/authentication.dart';
import 'package:handball_performance_tracker/features/statistics/statistics.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    StatisticsBloc statisticsBloc = context.read<StatisticsBloc>();
    GlobalBloc globalBloc = context.watch<GlobalBloc>();
    GlobalState globalState = globalBloc.state;
    if (globalState.status == GlobalStatus.success) {
      statisticsBloc.add(InitStatistics());
    }
    print("global state: ${globalState.status}");
    // final authState = context.watch<AuthBloc>().state;
    if (globalState.status == GlobalStatus.loading) {
      return Column(children: [
        Text("Loading...", style: TextStyle(fontSize: 20, color: Colors.blue)),
        Image.asset("files/Intercep_Logo.png"),
        CircularProgressIndicator(
          strokeWidth: 4,
        )
      ]);
    }
    if (globalState.status == GlobalStatus.success) {
      return const DashboardContent();
    }
    if (globalState.status == GlobalStatus.failure) {
      return Center(
        child: Container(),
      );
    } else {
      print("dashboard view: this should not happen");
      return const Center(
        child: Text("This should not happen [Dashboard]"),
      );
    }
  }
}
