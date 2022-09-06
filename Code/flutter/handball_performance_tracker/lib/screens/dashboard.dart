import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/colors.dart';
import 'package:handball_performance_tracker/constants/fieldSizeParameter.dart';
import 'package:handball_performance_tracker/screens/startGameScreen.dart';
import 'package:handball_performance_tracker/screens/statisticsScreen.dart';
import 'package:handball_performance_tracker/screens/teamSelectionScreen.dart';
import 'package:handball_performance_tracker/widgets/authentication_screen/alert_widget.dart';
import 'package:handball_performance_tracker/widgets/main_screen/ef_score_bar.dart';
import 'package:handball_performance_tracker/widgets/nav_drawer.dart';
import '../constants/stringsGeneral.dart';
import '../constants/stringsDashboard.dart';
import 'package:get/get.dart';
import '../controllers/persistentController.dart';
import '../controllers/tempController.dart';
import '../utils/initializeLocalData.dart';
import 'package:flutter/services.dart';

class Dashboard extends StatelessWidget {
  final PersistentController persistentController =
      Get.put(PersistentController());
  final TempController tempController = Get.put(TempController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return FutureBuilder(
        future: initializeLocalData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
                child: Scaffold(
                    backgroundColor: backgroundColor,
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
                          // Upper white bar with menu button etc
                          Container(
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Container for menu button on top left corner
                                MenuButton(_scaffoldKey),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(right: 10),
                                      child: new Image.asset(
                                        "assets/launcher_icon.png",
                                        height: buttonHeight * 0.8,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Text(
                                      persistentController
                                          .getLoggedInClub()
                                          .name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                                Text(""), // To be substituted by saison button
                              ],
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Buttons
                              Container(
                                child: Column(
                                  children: [
                                    StatisticsButton(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SquareDashboardButton(
                                            startButton: false),
                                        SquareDashboardButton(
                                            startButton: true),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
            return CustomAlertWidget("Lade Daten");
          }
        });
  }
}

class StatisticsButton extends StatelessWidget {
  const StatisticsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      width: screenWidth * 0.85,
      height: availableScreenHeight * 0.4,
      decoration: BoxDecoration(
          color: Colors.white,
          // set border so corners can be made round
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: TextButton(
          onPressed: () {
            Get.to(() => StatisticsScreen());
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bar_chart,
                color: Colors.black,
                size: 50,
              ),
              Text(
                StringsGeneral.lStatistics,
                style: TextStyle(color: Colors.black, fontSize: 30),
              )
            ],
          )),
    );
  }
}

class SquareDashboardButton extends StatelessWidget {
  bool startButton = false;
  SquareDashboardButton({Key? key, required this.startButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      width: screenWidth * 0.4,
      height: availableScreenHeight * 0.4,
      decoration: BoxDecoration(
          color: Colors.white,
          // set border so corners can be made round
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: TextButton(
          onPressed: () {
            startButton
                ? Get.to(() => StartGameScreen())
                : Get.to(() => TeamSelectionScreen());
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                startButton ? Icons.add : Icons.edit,
                color: Colors.black,
                size: 50,
              ),
              Text("   "),
              Text(
                startButton
                    ? StringsDashboard.lTrackNewGame
                    : StringsDashboard.lManageTeams,
                style: TextStyle(color: Colors.black, fontSize: 30),
              )
            ],
          )),
    );
  }
}
