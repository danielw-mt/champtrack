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
      print(teamManagementBloc.state.viewField);
      if (teamManagementBloc.state.viewField ==
          TeamManagementViewField.players) {
        return PlayersList();
      } else if (teamManagementBloc.state.viewField ==
          TeamManagementViewField.addingPlayers) {
        return PlayerForm(
          editModeEnabled: false,
        );
      } else if (teamManagementBloc.state.viewField ==
          TeamManagementViewField.addingTeams) {
        return NewAddTeamWidget();
      } else {
        return Container(child: Text("This should not happen"));
      }
    }

    return Scaffold(
      floatingActionButton: teamManagementBloc.state.viewField ==
              TeamManagementViewField.players
          ? FloatingActionButton(
              child: Icon(Icons.person_add),
              onPressed: () {
                print(TeamManagementViewField.addingPlayers);
                // teamManagementBloc.add(SelectViewField(
                //     viewField: TeamManagementViewField.addingPlayers));
                // print(teamManagementBloc.state.viewField);
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text(StringsTeamManagement.lAddPlayer),
                          content: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [PlayerForm(editModeEnabled: false)],
                            ),
                          ),
                        ));
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
          Expanded(flex: 4, child: buildViewArea()),

          // ElevatedButton(
          //     onPressed: () {
          //       showDialog(
          //           context: context,
          //           builder: (BuildContext context) => AlertDialog(
          //                 title: Text(StringsTeamManagement.lAddPlayer),
          //                 content: SizedBox(
          //                   width:
          //                       MediaQuery.of(context).size.width * 0.7,
          //                   height:
          //                       MediaQuery.of(context).size.height * 0.8,
          //                   child: Column(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       PlayerForm(editModeEnabled: false)
          //                     ],
          //                   ),
          //                 ),
          //                 actions: [
          //                   TextButton(
          //                     child: Text(StringsGeneral.lCancel),
          //                     onPressed: () {
          //                       Navigator.of(context).pop();
          //                     },
          //                   ),
          //                   TextButton(
          //                     child: Text(StringsGeneral.lSubmitButton),
          //                     onPressed: () {
          //                       Navigator.of(context).pop();
          //                     },
          //                   ),
          //                 ],
          //               ));
          //     },
          //     child: Text("Add player"))
        ],
      ),
    );
  }
}
