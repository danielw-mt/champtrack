import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/controllers/tempController.dart';
import 'package:handball_performance_tracker/widgets/nav_drawer.dart';
import 'package:handball_performance_tracker/widgets/statistic_screen/charts.dart';

// a screen that holds widgets that can be useful for debugging and game control
class StatisticsScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TempController tempController = Get.put(TempController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        drawer: NavDrawer(),
        // if drawer is closed notify, so if game is running the back to game button appears on next opening
        onDrawerChanged: (isOpened) {
          if (!isOpened) {
            tempController.setMenuIsEllapsed(false);
          }
        },
        body: Stack(
          children: [
            // Container for menu button on top left corner
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MenuButton(_scaffoldKey),
                  ],
                ),
                Expanded(
                  child: Card(
                      child: AspectRatio(
                          aspectRatio: 0.2 / 0.2, child: LineChartWidget())),
                ),
                Expanded(
                  child: Card(
                      child: AspectRatio(
                          aspectRatio: 0.2 / 0.2, child: LineChartWidget())),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
