import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/team_management/team_management.dart';
import 'package:handball_performance_tracker/core/core.dart';

class TeamList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalState = context.watch<GlobalBloc>().state;

    return BlocBuilder<TeamManagementBloc, TeamManagementState>(
        builder: (context, state) {
      if (globalState.allTeams.isEmpty) {
        // don't show the listview if there are no available teams
        return Center(
            child: Text(
          StringsGeneral.lNoTeamsWarning,
          style: TextStyle(fontSize: 20, color: Colors.blue),
        ));
      }
      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: globalState.allTeams.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              context.read<TeamManagementBloc>().add(SelectViewField(viewField: TeamManagementViewField.players));
              int selectedTeamIndex =
                  globalState.allTeams.indexOf(globalState.allTeams[index]);

              context
                  .read<TeamManagementBloc>()
                  .add(SelectTeam(index: selectedTeamIndex));
            },
            child: Card(
                child: ListTile(
                    title: Text(globalState.allTeams[index].name),
                    leading: Icon(Icons.group))),
          );
        },
      );
    });
  }
}
