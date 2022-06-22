import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/widgets/nav_drawer.dart';
import '../strings.dart';
import '../controllers/tempController.dart';
import './../widgets/settings_screen/game_start_stop_buttons.dart';

class SettingsScreen extends StatelessWidget {
  // screen that allows players to be selected including what players are on the field or on the bench (non selected)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container for menu button on top left corner
          MenuButton(_scaffoldKey),
          GameStartStopButtons(),
          const Text(Strings.lHomeSideIsRight),
          GetBuilder<TempController>(
              id: "side-switch",
              builder: (tempController) {
                return Switch(
                    value: tempController.getAttackIsLeft(),
                    onChanged: (bool) {
                      tempController
                          .setAttackIsLeft(!tempController.getAttackIsLeft());
                    });
              })
        ],
      ),
    );
  }
}
