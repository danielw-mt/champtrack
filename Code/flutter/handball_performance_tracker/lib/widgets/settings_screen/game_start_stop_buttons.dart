import 'package:flutter/material.dart';
import './../../controllers/globalController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GameStartStopButtons extends StatelessWidget {
  GlobalController globalController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: TextButton(onPressed: () {}, child: Text("Start Game")),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: TextButton(onPressed: () {}, child: Text("Stop Game")),
        )
      ],
    );
  }

  void startGame(){
    // check if enough players have been selected
    // start a new game in firebase
    // activate the game timer
  }

  void stopGame(){

  }
}
