import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/widgets/nav_drawer.dart';
import '../strings.dart';
import './../controllers/globalController.dart';

class SettingsScreen extends GetView<GlobalController> {
  // screen that allows players to be selected including what players are on the field or on the bench (non selected)
  final GlobalController globalController = Get.find<GlobalController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: NavDrawer(),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Container for menu button on top left corner
          MenuButton(_scaffoldKey),
          Text("Dashboard"),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {}, child: Text(Strings.lManageTeams)),
              ElevatedButton(
                  onPressed: () {}, child: Text(Strings.lTrackNewGame)),
            ],
          ),
        ]));
  }
}
