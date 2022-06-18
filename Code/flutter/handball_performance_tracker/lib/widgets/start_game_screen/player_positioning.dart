import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/../controllers/globalController.dart';
import '../../data/database_repository.dart';
import '../../strings.dart';
import '../../data/player.dart';

class PlayerPositioning extends StatefulWidget {
  const PlayerPositioning({Key? key}) : super(key: key);

  @override
  State<PlayerPositioning> createState() => _PlayerPositioningState();
}

class _PlayerPositioningState extends State<PlayerPositioning> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalController>(builder: (globalController) {
      int numberOfPlayers =
          globalController.selectedTeam.value.onFieldPlayers.length;
      List<Player> onFieldPlayers =
          globalController.selectedTeam.value.onFieldPlayers;
      return SizedBox(
          width: double.infinity,
          child: DataTable(
            columns: const <DataColumn>[
              DataColumn(label: Text(Strings.lPlayer)),
              DataColumn(label: Text(Strings.lShirtNumber)),
              DataColumn(
                label: Text(Strings.lPosition),
              ),
            ],
            rows: List<DataRow>.generate(
              numberOfPlayers,
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
                      return Colors.grey.withOpacity(0.3);
                    }
                    return null; // Use default value for other states and odd rows.
                  }),
                  cells: <DataCell>[
                    DataCell(Text(
                        "${onFieldPlayers[index].firstName} ${onFieldPlayers[index].lastName}")),
                    DataCell(Text(onFieldPlayers[index].number.toString())),
                    DataCell(Text("Test")),
                    // DataCell(SizedBox(
                    //   height: 30,
                    //   child: ListView.builder(
                    //       itemCount: 7,
                    //       shrinkWrap: true,
                    //       itemBuilder: (context, item) {
                    //         List<String> positionNames = [
                    //           Strings.lGoalkeeper,
                    //           Strings.lLeftBack,
                    //           Strings.lCenterBack,
                    //           Strings.lRightBack,
                    //           Strings.lLeftWinger,
                    //           Strings.lCenterForward,
                    //           Strings.lRightWinger
                    //         ];
                    //         return Row(
                    //           children: [
                    //             Text(positionNames[item]),
                    //             // TODO implement checkbox
                    //             Checkbox(value: false, onChanged: (value) {})
                    //           ],
                    //         );
                    //       }),
                    // ))
                  ],
                );
              },
            ),
          ));
    });
  }
}
