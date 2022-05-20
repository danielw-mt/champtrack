import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/controllers/globalController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_performance_tracker/widgets/main_screen/field.dart';
import './../widgets/nav_drawer.dart';
import 'package:handball_performance_tracker/controllers/fieldSizeParameter.dart'
    as fieldSizeParameter;

class MainScreen extends StatelessWidget {
  // screen where the game takes place
  final GlobalController globalController = Get.put(GlobalController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(title: const Text("Title")),
      body: Column(
        children: [
          SizedBox(
              // FieldSwitch to swipe between right and left field side. SizedBox around it so there is no rendering error.
              width: fieldSizeParameter.fieldWidth,
              height: fieldSizeParameter.fieldHeight,
              child: FieldSwitch()),
          TextButton(
              onPressed: () {},
              child: const Text(
                  "Testbutton")) // just a testbutton to see that it doesn't vanish when swiping from left to right field side
        ],
      ),
    );
  }
}
