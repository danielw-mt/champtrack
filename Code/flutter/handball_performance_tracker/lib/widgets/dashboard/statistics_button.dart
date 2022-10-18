import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/fieldSizeParameter.dart';
import 'package:handball_performance_tracker/screens/start_game_screen.dart';
import 'package:handball_performance_tracker/screens/team_selection_screen.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/constants/stringsDashboard.dart';
import 'package:handball_performance_tracker/constants/stringsGeneral.dart';
import 'package:handball_performance_tracker/screens/statistics_screen.dart';

class StatisticsButton extends StatelessWidget {
  const StatisticsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
          color: Colors.white,
          // set border so corners can be made round
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: TextButton(
          onPressed: () {
            Get.to(() => StatisticsScreen());
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bar_chart,
                color: Colors.black,
                size: 50,
              ),
              Text(
                StringsGeneral.lStatistics,
                style: TextStyle(color: Colors.black, fontSize: 30),
              )
            ],
          )),
    );
  }
}

class SquareDashboardButton extends StatelessWidget {
  bool startButton = false;
  SquareDashboardButton({Key? key, required this.startButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
          color: Colors.white,
          // set border so corners can be made round
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: TextButton(
          onPressed: () {
            startButton
                ? Get.to(() => StartGameScreen())
                : Get.to(() => TeamSelectionScreen());
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                startButton ? Icons.add : Icons.edit,
                color: Colors.black,
                size: 50,
              ),
              Text("   "),
              Text(
                startButton
                    ? StringsDashboard.lTrackNewGame
                    : StringsDashboard.lManageTeams,
                style: TextStyle(color: Colors.black, fontSize: 30),
              )
            ],
          )),
    );
  }
}