import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/screens/startGameScreen.dart';
import 'package:handball_performance_tracker/widgets/nav_drawer.dart';
import '../constants/stringsGeneral.dart';
import '../constants/stringsDashboard.dart';
import 'package:get/get.dart';
import '../controllers/persistentController.dart';
import '../controllers/tempController.dart';
import '../utils/initializeLocalData.dart';

class Dashboard extends StatelessWidget {
  final PersistentController persistentController =
      Get.put(PersistentController());
  final TempController tempController = Get.put(TempController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initializeLocalData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
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
                    body: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Container for menu button on top left corner
                          MenuButton(_scaffoldKey),
                          Text("Dashboard"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  onPressed: () {},
                                  child: Text(StringsDashboard.lManageTeams)),
                              ElevatedButton(
                                  onPressed: () {
                                    Get.to(() => StartGameScreen());
                                  },
                                  child: Text(StringsDashboard.lTrackNewGame)),
                            ],
                          ),
                        ])));
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            return Column(
              children: [
                Icon(Icons.error),
                Text("Couldn't get any data from Firebase")
              ],
            );
          } else {
            return Center(
              child: Column(
                children: [
                  Text(
                    "Loading data",
                  ),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            );
          }
        });
  }
}
