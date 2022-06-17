import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/widgets/nav_drawer.dart';
import './../../controllers/globalController.dart';

class PlaceholderScreen extends GetView<GlobalController> {
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
        ));
  }
}
