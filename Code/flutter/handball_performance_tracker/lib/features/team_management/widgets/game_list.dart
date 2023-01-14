import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/features/team_management/team_management.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/data/models/game_model.dart';
import 'package:handball_performance_tracker/data/models/team_model.dart';
import 'package:handball_performance_tracker/core/core.dart';

class GameList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TeamManagementState state = context.watch<TeamManagementBloc>().state;
    final globalState = context.watch<GlobalBloc>().state;
    if (globalState.allGames.length == 0) {
      return Center(
        child: Text(StringsGeneral.lNoPlayersWarning),
      );
    }
    final Team selectedTeam = globalState.allTeams[state.selectedTeamIndex];
    final List<Game> gamesList = globalState.allGames
        .where((Game game) => game.teamId == selectedTeam.id)
        .toList();
    return SingleChildScrollView(
      controller: ScrollController(),
      child: DataTable(
        columns: <DataColumn>[
          DataColumn(
            label: Text(StringsGeneral.lOpponent),
          ),
          DataColumn(
            label: Text(StringsGeneral.lDate),
          ),
          DataColumn(label: Text(StringsGeneral.lLocation)),
          DataColumn(label: Text(StringsGeneral.lDeleteGame, softWrap: true))
        ],
        rows: List<DataRow>.generate(
          gamesList.length,
          (int index) {
            return DataRow(
              color: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                // All rows will have the same selected color.
                if (states.contains(MaterialState.selected)) {
                  return Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.08);
                }
                // Even rows will have a grey color.
                if (index.isEven) {
                  return buttonGreyColor;
                }
                return null; // Use default value for other states and odd rows.
              }),
              cells: <DataCell>[
                DataCell(Text(gamesList[index].opponent!)),
                DataCell(
                    Text(gamesList[index].date.toString().substring(0, 10))),
                DataCell(Text(gamesList[index].location!)),
                DataCell(GestureDetector(
                  child: Center(child: Icon(Icons.delete)),
                  onTap: () {
                    // TODO replace alert with flutter dialog
                    // Alert(
                    //   context: context,
                    //   buttons: [],
                    //   content: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       Text(StringsGeneral.lGameDeleteWarning),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //         children: [
                    //           ElevatedButton(
                    //               onPressed: () {
                    //                 Navigator.pop(context);
                    //               },
                    //               child: Text(StringsGeneral.lCancel)),
                    //           ElevatedButton(
                    //               onPressed: () {
                    //                 context.read<TeamManagementCubit>().deleteGame(gamesList[index]);
                    //                 Navigator.pop(context);
                    //               },
                    //               child: Text(StringsGeneral.lConfirm)),
                    //         ],
                    //       )
                    //     ],
                    //   ),
                    // ).show();
                  },
                ))
              ],
            );
          },
        ),
      ),
    );
  }
}
