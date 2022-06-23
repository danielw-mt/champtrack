import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/controllers/tempController.dart';
import 'package:handball_performance_tracker/strings.dart';
import 'package:handball_performance_tracker/widgets/main_screen/ef_score_bar.dart';

class ScoreKeeping extends StatelessWidget {
  const ScoreKeeping({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TempController tempController = Get.find<TempController>();

    return Container(
      margin: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
          color: Color.fromARGB(103, 169, 172, 209),
          // set border so corners can be made round
          border: Border.all(
            color: Color.fromARGB(103, 169, 172, 209),
          ),
          // make round edges
          borderRadius: BorderRadius.all(Radius.circular(menuRadius))),
      child: Row(
        children: [
          // Plus and Minus buttons of own team
          Column(children: [
            TextButton(
              onPressed: () {
                tempController.incOwnScore();
              },
              child: Icon(Icons.add, size: 15, color: Colors.black),
            ),
            TextButton(
              onPressed: () {
                tempController.decOwnScore();
              },
              child: Icon(Icons.remove, size: 15, color: Colors.black),
            ),
          ]),
          // Name of own team
          Text(tempController.getSelectedTeam().name),
          // Container with Scores
          Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                // set border so corners can be made round
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.all(Radius.circular(menuRadius))),
            child: GetBuilder<TempController>(
                id: "score-keeping",
                builder: (tempController) {
                  return Text(
                    tempController.getOwnScore().toString() +
                        " : " +
                        tempController.getOpponentScore().toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
          ),
          // Name of opponent team
          Text(Strings.lOpponent),
          // Plus and Minus buttons of opponent team
          Column(children: [
            TextButton(
              onPressed: () {
                tempController.incOpponentScore();
              },
              child: Icon(Icons.add, size: 15, color: Colors.black),
            ),
            TextButton(
              onPressed: () {
                tempController.decOpponentScore();
              },
              child: Icon(Icons.remove, size: 15, color: Colors.black),
            )
          ]),
        ],
      ),
    );
  }
}
