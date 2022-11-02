import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/old-screens/start_game_screen.dart';
import 'package:handball_performance_tracker/core/constants/stringsDashboard.dart';

class StartNewGameButton extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 0.4,
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
            // if (tempController.getOldGameStateExists()) {
            // TODO implement dialog
            // Get.defaultDialog(
            //     title: StringsDashboard.lWarning,
            //     content: Column(
            //       children: [
            //         Text(StringsDashboard.lSkipGameRecreation),
            //         ElevatedButton(
            //             onPressed: () => Get.to(() => StartGameScreen()),
            //             child: Text(StringsDashboard.lContinue)),
            //       ],
            //     ));
            // } else {
            //Get.to(() => StartGameScreen());
            // }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Colors.black,
                size: 50,
              ),
              Text("   "),
              Text(
                StringsDashboard.lTrackNewGame,
                style: TextStyle(color: Colors.black, fontSize: 30),
              )
            ],
          )),
    );
  }
}
