import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:handball_performance_tracker/features/team_management/team_management.dart';
import 'package:handball_performance_tracker/data/repositories/repositories.dart';

class TeamManagementPage extends StatelessWidget {
  const TeamManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeamManagementCubit()..loadTeamManagement(),
      child: TeamManagementView(),
    );
  }
}
