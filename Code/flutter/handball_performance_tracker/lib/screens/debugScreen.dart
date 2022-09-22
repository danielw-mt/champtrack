import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/controllers/tempController.dart';
import 'package:handball_performance_tracker/widgets/nav_drawer.dart';

// a screen that holds widgets that can be useful for debugging and game control
class DebugScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // TODO Get.find instead of Get.put?
  final TempController tempController = Get.put(TempController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            drawer: NavDrawer(),
        // if drawer is closed notify, so if game is running the back to game button appears on next opening
        onDrawerChanged: (isOpened) {
          if (!isOpened) {
            tempController.setMenuIsEllapsed(false);
          }
        },
            body: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container for menu button on top left corner
                    MenuButton(_scaffoldKey),
                    Row(
                      children: [
                        Column(
                          children: [],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )));
  }
}
