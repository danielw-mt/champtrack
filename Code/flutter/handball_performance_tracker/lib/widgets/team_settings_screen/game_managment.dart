import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/constants/colors.dart';
import '../../controllers/persistent_controller.dart';
import '../../controllers/temp_controller.dart';
import '../../data/game.dart';
import '../../data/team.dart';
import '../../constants/stringsGeneral.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GameList extends StatelessWidget {
  const GameList({super.key});

  @override
  Widget build(BuildContext context) {
    TempController tempController = Get.find<TempController>();
    PersistentController persistentController = Get.find<PersistentController>();
    Team selectedTeam = tempController.getSelectedTeam();
    List<Game> gamesList = persistentController.getAllGames(teamId: selectedTeam.id);
    return SingleChildScrollView(
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: Text(StringsGeneral.lOpponent),
          ),
          DataColumn(
            label: Text(StringsGeneral.lDate),
          ),
          DataColumn(label: Text(StringsGeneral.lLocation)),
          DataColumn(label: Text(StringsGeneral.lDeleteGame))
        ],
        rows: List<DataRow>.generate(
          gamesList.length,
          (int index) {
            return DataRow(
              color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                // All rows will have the same selected color.
                if (states.contains(MaterialState.selected)) {
                  return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                }
                // Even rows will have a grey color.
                if (index.isEven) {
                  return buttonGreyColor;
                }
                return null; // Use default value for other states and odd rows.
              }),
              cells: <DataCell>[
                DataCell(Text(gamesList[index].opponent!)),
                DataCell(Text(gamesList[index].date.toString().substring(0, 10))),
                DataCell(Text(gamesList[index].location!)),
                DataCell(GestureDetector(
                  child: Icon(Icons.delete),
                  onTap: () {
                    Alert(
                      context: context,
                      buttons: [],
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(StringsGeneral.lGameDeleteWarning),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(StringsGeneral.lCancel)),
                                ElevatedButton(
                                    onPressed: () {
                                      persistentController.deleteGame(gamesList[index]);
                                      Navigator.pop(context);
                                    },
                                    child: Text(StringsGeneral.lConfirm)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ).show();
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
