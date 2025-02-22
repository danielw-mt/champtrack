import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/team_management/team_management.dart';
import 'package:handball_performance_tracker/core/core.dart';

class TeamManagementPlayers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final teamManagementBloc = context.watch<TeamManagementBloc>();
    final globalBloc = context.watch<GlobalBloc>();

    Widget buildViewArea() {
      if (teamManagementBloc.state.viewField ==
          TeamManagementViewField.players) {
        return PlayersList();
      } else if (teamManagementBloc.state.viewField ==
          TeamManagementViewField.addingPlayers) {
        return PlayerEditWidget(
          editModeEnabled: false,
        );
      } else if (teamManagementBloc.state.viewField ==
          TeamManagementViewField.addingTeams) {
        return AddNewTeam();
      } else if (teamManagementBloc.state.viewField ==
          TeamManagementViewField.editPlayer) {
        return PlayerEditWidget(
          editModeEnabled: true,
          player: teamManagementBloc.state.selectedPlayer,
        );
      } else {
        return Container(child: Text("This should not happen"));
      }
    }

    return Scaffold(
      floatingActionButton: (teamManagementBloc.state.viewField ==
                  TeamManagementViewField.players &&
              globalBloc.state.allTeams.length != 0)
          ? FloatingActionButton(
              child: Icon(Icons.person_add),
              onPressed: () {
                // print(TeamManagementViewField.addingPlayers);
                teamManagementBloc.add(SelectViewField(
                    viewField: TeamManagementViewField.addingPlayers));
                // print(teamManagementBloc.state.viewField);
              })
          : Container(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(flex: 9, child: TeamList()),
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                    // on pressed trigger teamManagementBloc.add(PressAddTeam())
                    onPressed: () {
                      teamManagementBloc.add(SelectViewField(
                          viewField: TeamManagementViewField.addingTeams));
                      print(teamManagementBloc.state.viewField);
                    },
                    child: Text(StringsTeamManagement.lAddTeam),
                  ),
                )
              ],
            ),
          ),
          Expanded(
              flex: 4,
              child: Column(children: [Expanded(child: buildViewArea())])),
        ],
      ),
    );
  }
}
