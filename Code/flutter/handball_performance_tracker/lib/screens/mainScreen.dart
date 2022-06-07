import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/controllers/globalController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_performance_tracker/utils/initializeLocalData.dart';
import 'package:handball_performance_tracker/widgets/main_screen/field.dart';
import './../widgets/nav_drawer.dart';
import 'package:handball_performance_tracker/utils/fieldSizeParameter.dart'
    as fieldSizeParameter;
import 'package:flutter/services.dart';

class MainScreen extends StatelessWidget {
  // screen where the game takes place
  final GlobalController globalController = Get.put(GlobalController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    return FutureBuilder(
      future: initializeLocalData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            drawer: NavDrawer(),
            appBar: AppBar(title: const Text("Title")),
            body: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      // set border around field
                      border: Border.all(width: fieldSizeParameter.lineSize)),
                  child: SizedBox(
                    // FieldSwitch to swipe between right and left field side. SizedBox around it so there is no rendering error.
                    width: fieldSizeParameter.fieldWidth,
                    height: fieldSizeParameter.fieldHeight,
                    child: FieldSwitch(),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
