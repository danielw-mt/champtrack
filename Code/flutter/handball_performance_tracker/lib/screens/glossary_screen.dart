import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/constants/fieldSizeParameter.dart';
import 'package:handball_performance_tracker/constants/game_actions.dart';
import 'package:handball_performance_tracker/controllers/temp_controller.dart';
import 'package:handball_performance_tracker/widgets/nav_drawer.dart';

import '../constants/colors.dart';

// a screen that holds widgets that can be useful for debugging and game control
class GlossaryScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // TODO Get.find instead of Get.put?
  final TempController tempController = Get.put(TempController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: buttonDarkBlueColor,
                title: Text("Glossar")),
            key: _scaffoldKey,
            drawer: NavDrawer(),
            // if drawer is closed notify, so if game is running the back to game button appears on next opening
            onDrawerChanged: (isOpened) {
              if (!isOpened) {
                tempController.setMenuIsEllapsed(false);
              }
            },
            body: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container for menu button on top left corner
                    //MenuButton(_scaffoldKey),

                    Expanded(
                      child: SingleChildScrollView(
                        controller: ScrollController(),
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columns: [
                            DataColumn(
                                label: Text('Aktion',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Beschreibung',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))),
                          ],
                          rows: [
                            DataRow(cells: [
                              DataCell(Text('Tor')),
                              DataCell(
                                  Text('Player erziehlt regelkonform ein Tor')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('Assist')),
                              DataCell(Text(
                                  'Ein Player bereitet ein Tor mit einer unmittelbaren Aktion vor')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('Fehlwurf')),
                              DataCell(Text(
                                  'Ein Player nimmt den Abschluss verwirft aber und bekommt auch kein Foul zugesprochen')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('Foul')),
                              DataCell(Text(
                                  'Ein Player begeht ein einfaches Foul (hier nicht Stürmerfoul)')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('2min ziehen')),
                              DataCell(Text(
                                  'Ein Player zwingt mit einer Offensiv-Aktion die Abwehr zu einer Aktion welche mit einer 2min Strafe belegt wird')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('2min Zeitstrafe')),
                              DataCell(Text(
                                  'Ein Player wird nach einer Aktion vom Schiedsrichter mit einer 2min Zeitstrafe belegt')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('7m ziehen')),
                              DataCell(Text(
                                  'Ein Player zwingt die Abwehr mit einer 1vs1 Situation zu einer Aktion welche mit einem 7m bestraft wird')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('7m Strafwurf')),
                              DataCell(Text(
                                  'Nach einer Aktion wird auf einen 7m Strafwurf entschieden')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('Gelbe Karte')),
                              DataCell(Text(
                                  'Eine Aktion eines Players wird mit der gelben Karte bestraft')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('Rote Karte')),
                              DataCell(Text(
                                  'Sich häufende Zeitstrafen oder eine einzelne Aktion führen zu einer roten Karte')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('Block')),
                              DataCell(Text(
                                  'Ein Player blockt den Wurfversuch eines Gegners')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('Block + Steal')),
                              DataCell(Text(
                                  'Ein Block resultiert in einem direkten Ballgewinn für das Team')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('Technischer Fehler')),
                              DataCell(Text(
                                  'Ein Player begeht einen der folgenden Fehler: Stürmerfoul, Tippfehler, Schrittfehler, Fehlpass, Fangfehler, \nFalsch ausgeführter Freiwurf/7m/Einwurf, Übertritt, Laufen durch den Kreis, Ball übergeben, Anlaufen aus dem Aus')),
                            ]),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )));
  }
}
