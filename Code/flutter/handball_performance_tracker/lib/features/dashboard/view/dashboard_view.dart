import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/dashboard/dashboard.dart';
import 'package:handball_performance_tracker/core/core.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final globalState = context.watch<GlobalBloc>().state;
    if (globalState.status == GlobalStatus.loading) {
      return Column(children: [
        Text("Loading...", style: TextStyle(fontSize: 20, color: Colors.blue)),
        Image.asset("images/goalee_gif.gif"),
        CircularProgressIndicator(
          strokeWidth: 4,
        )
      ]);
    }
    if (globalState.status == GlobalStatus.success) {
      return const DashboardContent();
    }
    return const Center(
      child: Text("TODO: Error"),
    );
  }
}
