import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/constants/colors.dart';
import '../../controllers/persistent_controller.dart';
import '../../controllers/temp_controller.dart';
import '../../data/game.dart';
import '../../data/team.dart';
import '../../constants/stringsGeneral.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// Widget is only statful so we can trigger a rebuild when we delete a game
class GameList extends StatefulWidget {
  const GameList({super.key});

  @override
  State<GameList> createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  TempController _tempController = Get.find<TempController>();
  PersistentController _persistentController = Get.find<PersistentController>();
  List<Game> gamesList = [];
  @override
  Widget build(BuildContext context) {
    print("rebuild view");
    Team selectedTeam = _tempController.getSelectedTeam();
    gamesList = _persistentController.getAllGames(teamId: selectedTeam.id);
    print("gamesList: " + gamesList.length.toString());
    return SingleChildScrollView(
      child: DataTable(
        columns: <DataColumn>[
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
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(StringsGeneral.lGameDeleteWarning + "\n" + "Bitte nach dem Löschen eines Spiels kurz die Spielübersicht neu laden"),
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
                                    _persistentController.deleteGame(gamesList[index]);
                                    setState(() {
                                      gamesList.removeAt(index);
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text(StringsGeneral.lConfirm)),
                            ],
                          )
                        ],
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
