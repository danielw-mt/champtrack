import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:handball_performance_tracker/dashboard/dashboard.dart';
import 'package:handball_performance_tracker/data/repositories/club_repository.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardBloc(clubRepository: context.read<ClubRepository>())..createDashboard(),
      child: const DashboardView(),
    );
  }
}
