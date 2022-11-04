import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/constants/colors.dart';
import 'package:handball_performance_tracker/old-widgets/nav_drawer.dart';
import 'package:get/get.dart';
import '../oldcontrollers/persistent_controller.dart';
import '../oldcontrollers/temp_controller.dart';
import '../old-utils/initialize_local_data.dart';
import '../old-widgets/dashboard/start_new_game_button.dart';
import '../old-widgets/dashboard/manage_teams_button.dart';
import '../old-widgets/dashboard/statistics_button.dart';
import '../core/constants/stringsGeneral.dart';

class Dashboard extends StatelessWidget {
  final PersistentController persistentController = Get.put(PersistentController());
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
                    appBar: AppBar(
                        backgroundColor: buttonDarkBlueColor,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /*Container(
                          padding: EdgeInsets.only(right: 10),
                          child: new Image.asset(
                            "images/launcher_icon.png",
                            height: MediaQuery.of(context).size.height * 0.1,
                            fit: BoxFit.cover,
                          ),
                        ),*/
                            Text(
                              persistentController.getLoggedInClub().name,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ],
                        )),
                    // if drawer is closed notify, so if game is running the back to game button appears on next opening
                    onDrawerChanged: (isOpened) {
                      if (!isOpened) {
                        tempController.setMenuIsEllapsed(false);
                      }
                    },
                    body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      // Upper white bar with menu button etc
                      /*Container(
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Container for menu button on top left corner
                                //MenuButton(_scaffoldKey),
                                
                                Text(""), // To be substituted by saison button
                              ],
                            ),
                          ),*/

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Buttons
                          Container(
                            child: Column(
                              children: [
                                StatisticsButton(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ManageTeamsButton(),
                                    StartNewGameButton(),
                                    // Take game restore out for now (18.10.22)
                                    //OldGameCard()
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
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: Icon(
                      Icons.wifi_off,
                    )),
                    Center(
                        child: Text(
                      StringsGeneral.lNoConnection,
                      style: TextStyle(fontSize: 30),
                    )),
                  ],
                ),
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Loading...", style: TextStyle(fontSize: 20, color: Colors.blue)),
                Image.asset("images/goalee_gif.gif"),
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
