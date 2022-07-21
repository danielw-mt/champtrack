import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/controllers/tempController.dart';
import 'package:handball_performance_tracker/widgets/nav_drawer.dart';

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

            Center(
              child: SizedBox.expand(
                //  height: availableScreenHeight,
                //  width: screenWidth * 0.8,
                child: PageView(
                  children: <Widget>[
                    Container(
                      child: new Image.asset(
                        "assets/statistics1.png",
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Container(
                      child: new Image.asset(
                        "assets/statistics2.png",
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Container(
                      child: new Image.asset(
                        "assets/statistics3.png",
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            MenuButton(_scaffoldKey),
          ],
        ),
      ),
    );
  }
}
