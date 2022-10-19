import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/colors.dart';
import 'package:handball_performance_tracker/controllers/temp_controller.dart';
import 'package:handball_performance_tracker/widgets/main_screen/ef_score_bar.dart';
import 'package:handball_performance_tracker/widgets/main_screen/ef_score_bar.dart'
    as efscorebar;
import 'package:handball_performance_tracker/widgets/main_screen/field.dart';
import 'package:handball_performance_tracker/widgets/main_screen/score_keeping.dart';
import 'package:handball_performance_tracker/widgets/main_screen/stop_game.dart';
import 'package:handball_performance_tracker/widgets/main_screen/side_switch.dart';
import './../widgets/nav_drawer.dart';
import 'package:handball_performance_tracker/constants/fieldSizeParameter.dart'
    as fieldSizeParameter;
import 'package:flutter/services.dart';
import '../widgets/main_screen/stopwatchbar.dart';
import '../widgets/main_screen/action_feed.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  // screen where the game takes place

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TempController tempController = Get.find<TempController>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      drawer: NavDrawer(),
      // if drawer is closed notify, so if game is running the back to game button appears on next opening
      onDrawerChanged: (isOpened) {
        if (!isOpened) {
          tempController.setMenuIsEllapsed(false);
        }
      },
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Row(
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
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      ActionFeed(),
                      Row(
                        children: [
                          StopGameButton(),
                          SideSwitch(),
                        ],
                      ), 
                      //FloatingActionButton(onPressed: () => null,)
                    ],
                  ),
                  // Player Bar
                  Container(
                      width: efscorebar.scorebarWidth +
                          efscorebar.paddingWidth * 4,
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
                                border: Border.all(
                                    width: fieldSizeParameter.lineSize)),
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
                                      constraints.maxWidth,
                                      constraints.maxHeight);
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
        ],
      ),
    ));
  }
}
