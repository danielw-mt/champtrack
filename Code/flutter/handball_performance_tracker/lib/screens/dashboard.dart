import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/colors.dart';
import 'package:handball_performance_tracker/widgets/authentication_screen/alert_widget.dart';
import 'package:handball_performance_tracker/widgets/main_screen/ef_score_bar.dart';
import 'package:handball_performance_tracker/widgets/nav_drawer.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../controllers/persistentController.dart';
import '../controllers/tempController.dart';
import '../utils/initializeLocalData.dart';
import '../widgets/dashboard/start_new_game_button.dart';
import '../widgets/dashboard/manage_teams_button.dart';
import '../widgets/dashboard/statistics_button.dart';
import '../widgets/dashboard/old_game_card.dart';

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
                                        ManageTeamsButton(),
                                        StartNewGameButton(),
                                        OldGameCard()
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
            return CustomAlertWidget("Initializing local data");
          }
        });
  }
}
