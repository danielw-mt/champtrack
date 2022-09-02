import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/fieldSizeParameter.dart';
import 'package:handball_performance_tracker/screens/startGameScreen.dart';
import 'package:handball_performance_tracker/screens/teamSelectionScreen.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/constants/stringsDashboard.dart';

class ManageTeamsButton extends StatelessWidget {
  bool startButton = false;
  ManageTeamsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      width: screenWidth * 0.4,
      height: availableScreenHeight * 0.4,
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
