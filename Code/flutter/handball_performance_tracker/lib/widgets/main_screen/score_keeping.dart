import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/constants/colors.dart';
import 'package:handball_performance_tracker/constants/stringsGeneral.dart';
import 'package:handball_performance_tracker/controllers/tempController.dart';
import 'package:handball_performance_tracker/widgets/main_screen/ef_score_bar.dart';

class ScoreKeeping extends StatelessWidget {
  const ScoreKeeping({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TempController tempController = Get.find<TempController>();

    return Container(
      margin: EdgeInsets.only(left: 30),
      decoration: BoxDecoration(
          color: buttonGreyColor,
          // set border so corners can be made round
          border: Border.all(
            color: buttonGreyColor,
          ),
          // make round edges
          borderRadius: BorderRadius.all(Radius.circular(menuRadius))),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Plus and Minus buttons of own team
            Column(children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                      buttonLightBlueColor, // This is a custom color variable
                ),
                onPressed: () {
                  tempController.incOwnScore();
                },
                child: Icon(Icons.add, size: 15, color: Colors.black),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                      buttonLightBlueColor, // This is a custom color variable
                ),
                onPressed: () {
                  tempController.decOwnScore();
                },
                child: Icon(Icons.remove, size: 15, color: Colors.black),
              ),
            ]),
            // Name of own team
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(5.0),
              child: Text(
                tempController.getSelectedTeam().name,
                textAlign: TextAlign.center,
              ),
            ),
            // Container with Scores
            Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              padding: const EdgeInsets.all(10.0),
              alignment: Alignment.center,
              color: Colors.white,
              child: GetBuilder<TempController>(
                  id: "score-keeping",
                  builder: (tempController) {
                    return Text(
                      tempController.getOwnScore().toString() +
                          " : " +
                          tempController.getOpponentScore().toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    );
                  }),
            ),
            // Name of opponent team
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  StringsGeneral.lOpponent,
                  textAlign: TextAlign.center,
                )),
            // Plus and Minus buttons of opponent team
            Column(children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                      buttonLightBlueColor, // This is a custom color variable
                ),
                onPressed: () {
                  tempController.incOpponentScore();
                },
                child: Icon(Icons.add, size: 15, color: Colors.black),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                      buttonLightBlueColor, // This is a custom color variable
                ),
                onPressed: () {
                  tempController.decOpponentScore();
                },
                child: Icon(Icons.remove, size: 15, color: Colors.black),
              )
            ]),
          ],
        ),
      ),
    );
  }
}
