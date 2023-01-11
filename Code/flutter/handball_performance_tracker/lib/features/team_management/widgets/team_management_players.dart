import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/team_management/team_management.dart';
import 'package:handball_performance_tracker/core/core.dart';

class TeamManagementPlayers extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    TeamManagementBloc teamManagementBloc =
        BlocProvider.of<TeamManagementBloc>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.person_add),
          onPressed: () {
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
                      // actions: [
                      //   TextButton(
                      //     child: Text(StringsGeneral.lCancel),
                      //     onPressed: () {
                      //       Navigator.of(context).pop();
                      //     },
                      //   ),
                      //   TextButton(
                      //     child: Text(StringsGeneral.lSubmitButton),
                      //     onPressed: () {
                      //       Navigator.of(context).pop();
                      //     },
                      //   ),
                      // ],
                    ));
          }),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Flexible(child: Text("Team auswählen")),
                Expanded(child: TeamList()),
                Flexible(
                  child: ElevatedButton(
                    onPressed: (() => showDialog(
                        context: context,
                        builder: (context) =>
                            BlocProvider<TeamManagementBloc>.value(
                              value: teamManagementBloc,
                              child: AlertDialog(
                                title: Text(StringsGeneral.lAddTeam),
                                content: NewTeamForm(),
                              ),
                            ))),
                    child: Text(StringsTeamManagement.lAddTeam),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(child: PlayersList()),
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
          ),
        ],
      ),
    );
  }
}
