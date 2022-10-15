import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/colors.dart';
import 'package:handball_performance_tracker/widgets/authentication_screen/alert_widget.dart';
import 'package:handball_performance_tracker/widgets/main_screen/ef_score_bar.dart';
import 'package:handball_performance_tracker/widgets/nav_drawer.dart';
import 'package:get/get.dart';
import '../controllers/persistent_controller.dart';
import '../controllers/temp_controller.dart';
import '../utils/initialize_local_data.dart';
import '../widgets/dashboard/start_new_game_button.dart';
import '../widgets/dashboard/manage_teams_button.dart';
import '../widgets/dashboard/statistics_button.dart';
import '../widgets/dashboard/old_game_card.dart';

class Dashboard extends StatelessWidget {
  final PersistentController persistentController = Get.put(PersistentController());
  final TempController tempController = Get.put(TempController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                    body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      MenuButton(_scaffoldKey),
                      // Upper white bar with menu button etc
                      Flexible(
                        flex: 1,
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Container for menu button on top left corner
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  new Image.asset(
                                    "assets/launcher_icon.png",
                                    height: height * 0.1,
                                  ),
                                  Container(width: 20,),
                                  Text(
                                    persistentController.getLoggedInClub().name,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: height / 100 * 2),
                                  ),
                                ],
                              ),
                              // Text("Season"), // To be substituted by saison button
                            ],
                          ),
                        ),
                      ),
                      Flexible(flex: 5, child: StatisticsButton()),
                      Flexible(
                        flex: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [Flexible(child: ManageTeamsButton()), Flexible(child: StartNewGameButton()), OldGameCard()],
                        ),
                      ),
                    ])));
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            return Column(
              children: [Icon(Icons.error), Text("Couldn't get any data from Firebase")],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Loading...", style: TextStyle(fontSize: 20, color: Colors.blue)),
                Image.asset("assets/goalee_gif.gif"),
                CircularProgressIndicator(
                  strokeWidth: 4,
                )
              ],
            );
            //return CustomAlertWidget("Initializing local data");
          }
        });
  }
}
