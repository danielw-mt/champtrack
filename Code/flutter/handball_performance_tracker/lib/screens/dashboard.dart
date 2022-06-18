import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/screens/startGameScreen.dart';
import 'package:handball_performance_tracker/widgets/nav_drawer.dart';
import '../strings.dart';
import 'package:get/get.dart';
import '../controllers/globalController.dart';

class Dashboard extends StatelessWidget {
  final GlobalController globalController = Get.put(GlobalController());
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {}, child: Text(Strings.lManageTeams)),
              ElevatedButton(
                  onPressed: () {
                    Get.to(StartGameScreen());
                  },
                  child: Text(Strings.lTrackNewGame)),
            ],
          ),
        ]));
  }
}
