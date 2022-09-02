import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/controllers/tempController.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/constants/stringsDashboard.dart';


class OldGameCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TempController>(builder: (tempController){
      if(tempController.oldGameStateExists()){
        return Card(
          child: Text(StringsDashboard.lRecreateOldGame)
        );
      } else {
        return Container();
      }
    });
  }
}