import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/colors.dart';
import 'package:handball_performance_tracker/widgets/main_screen/ef_score_bar.dart';
import 'package:handball_performance_tracker/widgets/main_screen/ef_score_bar.dart'
    as efscorebar;
import 'package:handball_performance_tracker/widgets/main_screen/field.dart';
import 'package:handball_performance_tracker/widgets/main_screen/score_keeping.dart';
import '../constants/stringsGeneral.dart';
import './../widgets/nav_drawer.dart';
import 'package:handball_performance_tracker/constants/fieldSizeParameter.dart'
    as fieldSizeParameter;
import 'package:flutter/services.dart';
import '../widgets/main_screen/stopwatchbar.dart';
import '../widgets/main_screen/action_feed.dart';

class MainScreen extends StatelessWidget {
  // screen where the game takes place

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(),
      backgroundColor: backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  MenuButton(_scaffoldKey),
                  ScoreKeeping(),
                ],
              ),
              StopWatchBar(),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ActionFeed(),
              // Player Bar
              Container(
                  width: efscorebar.scorebarWidth + efscorebar.paddingWidth * 4,
                  height: fieldSizeParameter.fieldHeight +
                      fieldSizeParameter.toolbarHeight / 4,
                  alignment: Alignment.topCenter,
                  child: EfScoreBar()),
              // Field
              Flexible(
                flex: 4,
                child: Column(
                  children: [
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
                          // Use a LayoutBuilder to get the real size of SizedBox.
                          // As it is inside Flexible Widget, the size can vary depending on screen size.
                          child: new LayoutBuilder(
                            builder: (BuildContext context,
                                BoxConstraints constraints) {
                              // set Field size depending on Widget size
                              fieldSizeParameter.setFieldSize(
                                  constraints.maxWidth, constraints.maxHeight);
                              return FieldSwitch();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
