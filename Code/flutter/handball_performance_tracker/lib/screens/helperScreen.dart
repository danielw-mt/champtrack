import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/data/ef_score.dart';
import 'package:handball_performance_tracker/widgets/main_screen/ef_score_bar.dart';
import 'package:handball_performance_tracker/widgets/nav_drawer.dart';
import './../../controllers/globalController.dart';
import './../widgets/helper_screen/stopwatch.dart';
import '../widgets/main_screen/action_menu.dart';
import '../widgets/main_screen/playermenu.dart';
import './../widgets/helper_screen/reverse_button.dart';
import './../widgets/helper_screen/action_feed.dart';

class HelperScreen extends GetView<GlobalController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: NavDrawer(),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
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
                Column(
                  children: [StopWatch(), ReverseButton(), ActionFeed()],
                ),
                EfScoreBar()
              ],
            ),
          ],
        ));
  }
}
