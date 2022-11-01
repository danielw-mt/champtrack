import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/dashboard/dashboard.dart';
import 'package:handball_performance_tracker/data/models/club_model.dart';
import 'package:handball_performance_tracker/old-constants/colors.dart';
import 'package:handball_performance_tracker/old-widgets/nav_drawer.dart';
import 'package:handball_performance_tracker/dashboard/widgets/widgets.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardState = context.watch<DashboardBloc>().state;
    String clubName = "";
    switch (dashboardState.status) {
      case DashboardStatus.initial:
        clubName = "Loading...";
        break;
      case DashboardStatus.loading:
        clubName = "Loading...";
        break;
      case DashboardStatus.success:
        clubName = dashboardState.club.name;
        break;
      case DashboardStatus.failure:
        clubName = "Error";
        break;
    }

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(clubName)],
      )),
    ));
  }
}
