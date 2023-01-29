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
    final globalBloc = context.watch<GlobalBloc>();
    if (globalBloc.state.allGames.length == 0) {
      return Center(
        child: Text(StringsGeneral.lNoGamesWarning),
      );
    }
    final Team selectedTeam =
        globalBloc.state.allTeams[state.selectedTeamIndex];
    final List<Game> gamesList = globalBloc.state.allGames
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
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text(StringsTeamManagement.lRemovePlayer),
                              content: SizedBox(
                                child: Text(StringsTeamManagement
                                    .lRemoveGameConfirmation),
                              ),
                              actions: [
                                TextButton(
                                  child: Text(StringsGeneral.lCancel),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text(StringsTeamManagement.lConfirm),
                                  onPressed: () {
                                    globalBloc.add(
                                        DeleteGame(game: gamesList[index]));
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ));
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
