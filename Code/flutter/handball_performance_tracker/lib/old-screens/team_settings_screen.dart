// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:handball_performance_tracker/core/constants/stringsGeneral.dart';
// import 'package:handball_performance_tracker/core/constants/stringsTeamManagement.dart';
// import '../../old-widgets/nav_drawer.dart';
// import '../oldcontrollers/temp_controller.dart';
// import '../../old-widgets/team_settings_screen/players_list.dart';
// import '../../old-widgets/team_settings_screen/team_settings_bar.dart';
// import '../../old-widgets/team_settings_screen/team_details_form.dart';
// import '../../old-widgets/team_settings_screen/player_edit_form.dart';
// import '../../old-widgets/team_settings_screen/game_managment.dart';
// import '../core/constants/colors.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';

// // A screen where all relevant Infos of a team can be edited (players, game history and team details like name)
// // screen that allows players to be selected including what players are on the field or on the bench (non selected)

// class TeamSettingsScreen extends StatelessWidget {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   // TODO Get.find instead of Get.put?
//   final TempController tempController = Get.put(TempController());

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: GetBuilder<TempController>(
//       id: "team-setting-screen",
//       builder: (gameController) {
//         return DefaultTabController(
//           initialIndex: gameController.getSelectedTeamSetting(),
//           length: 3,
//           child: Scaffold(
//               appBar: AppBar(
//                   backgroundColor: buttonDarkBlueColor, title: Text("Teams")),
//               key: _scaffoldKey,
//               drawer: NavDrawer(),
//               // if drawer is closed notify, so if game is running the back to game button appears on next opening
//               onDrawerChanged: (isOpened) {
//                 if (!isOpened) {
//                   tempController.setMenuIsEllapsed(false);
//                 }
//               },
//               bottomNavigationBar: TeamSettingsBar(),
//               body:
//                   Column(mainAxisAlignment: MainAxisAlignment.start, children: [
//                 if (gameController.getSelectedTeamSetting() == 0) ...[
//                   Expanded(
//                       child: Column(children: [
//                     Expanded(child: PlayersList()),
//                     Flexible(
//                         child: ElevatedButton(
//                             onPressed: () {
//                               Alert(
//                                 context: context,
//                                 buttons: [],
//                                 content: SizedBox(
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.7,
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.7,
//                                   child: Column(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: [PlayerForm()],
//                                   ),
//                                 ),
//                               ).show();
//                             },
//                             child: Text(StringsTeamManagement.lAddPlayer))),
//                   ]))
//                 ],
//                 if (gameController.getSelectedTeamSetting() == 1)
//                   Expanded(child: Center(child: GameList())),
//                 if (gameController.getSelectedTeamSetting() == 2)
//                   Center(child: TeamDetailsForm())
//               ])),
//         );
//       },
//     ));
//   }
// }
