import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/controllers/globalController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_performance_tracker/utils/initializeLocalData.dart';
import 'package:handball_performance_tracker/widgets/main_screen/ef_score_bar.dart';
import 'package:handball_performance_tracker/widgets/main_screen/ef_score_bar.dart'
    as efscorebar;
import 'package:handball_performance_tracker/widgets/main_screen/field.dart';
import './../widgets/nav_drawer.dart';
import 'package:handball_performance_tracker/utils/fieldSizeParameter.dart'
    as fieldSizeParameter;
import 'package:flutter/services.dart';
import '../widgets/main_screen/stopwatchbar.dart';
import '../widgets/main_screen/action_feed.dart';

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
            key: _scaffoldKey,
            drawer: NavDrawer(),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container for menu button on top left corner
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      color: Colors.white),
                  child: IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Feed"),
                        ActionFeed(),
                        //Spacer(flex: 1,),
                        Container()
                      ],
                    ),
                    Spacer(flex: 1,),
                    // Player Bar
                    Container(
                        width: efscorebar.scorebarWidth +
                            efscorebar.paddingWidth * 4,
                        height: fieldSizeParameter.fieldHeight +
                            fieldSizeParameter.toolbarHeight / 4,
                        alignment: Alignment.topCenter,
                        child: EfScoreBar()),
                    // Field
                    Column(
                      children: [
                        StopWatchBar(),
                        Container(
                          width: fieldSizeParameter.fieldWidth +
                              fieldSizeParameter.toolbarHeight / 4,
                          height: fieldSizeParameter.fieldHeight +
                              fieldSizeParameter.toolbarHeight / 4,
                          alignment: Alignment.topCenter,
                          child: Container(
                            decoration: BoxDecoration(
                                // set border around field
                                border:
                                    Border.all(width: fieldSizeParameter.lineSize)),
                            child: SizedBox(
                              // FieldSwitch to swipe between right and left field side. SizedBox around it so there is no rendering error.
                              width: fieldSizeParameter.fieldWidth,
                              height: fieldSizeParameter.fieldHeight,
                              child: FieldSwitch(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
