import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/team_management/team_management.dart';

class TeamManagementGames extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TeamManagementBloc teamManagementBloc =
    //     BlocProvider.of<TeamManagementBloc>(context);
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: Column(
              children: [
                Expanded(child: TeamList()),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(child: GameList()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
