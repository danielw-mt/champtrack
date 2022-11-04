// import 'package:flutter/material.dart';
// import 'package:handball_performance_tracker/core/constants/fieldSizeParameter.dart';
// import 'package:handball_performance_tracker/old-screens/dashboard.dart';
// import 'package:handball_performance_tracker/old-screens/start_game_screen.dart';
// import 'package:handball_performance_tracker/old-screens/team_selection_screen.dart';
// import 'package:get/get.dart';
// import 'package:handball_performance_tracker/core/constants/stringsDashboard.dart';
// import 'package:handball_performance_tracker/oldcontrollers/temp_controller.dart';
// import '../../../../old-widgets/helper_screen/alert_message_widget.dart';
// import 'package:handball_performance_tracker/core/constants/stringsGameSettings.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';

// class StartNewGameButton extends StatelessWidget {
//   final navigatorKey = GlobalKey<NavigatorState>();

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<TempController>(
//       builder: (tempController) => Container(
//         margin: EdgeInsets.all(20),
//         width: MediaQuery.of(context).size.width * 0.4,
//         height: MediaQuery.of(context).size.height * 0.3,
//         decoration: BoxDecoration(
//             color: Colors.white,
//             // set border so corners can be made round
//             border: Border.all(
//               color: Colors.white,
//             ),
//             borderRadius: BorderRadius.all(Radius.circular(15))),
//         child: TextButton(
//             onPressed: () {
//               if (tempController.getOldGameStateExists()) {
//                 Get.defaultDialog(
//                     title: StringsDashboard.lWarning,
//                     content: Column(
//                       children: [
//                         Text(StringsDashboard.lSkipGameRecreation),
//                         ElevatedButton(
//                             onPressed: () => Get.to(() => StartGameScreen()),
//                             child: Text(StringsDashboard.lContinue)),
//                       ],
//                     ));
//               } else {
//                 Get.to(() => StartGameScreen());
//               }
//             },
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.add,
//                   color: Colors.black,
//                   size: 50,
//                 ),
//                 Text("   "),
//                 Text(
//                   StringsDashboard.lTrackNewGame,
//                   style: TextStyle(color: Colors.black, fontSize: 30),
//                 )
//               ],
//             )),
//       ),
//     );
//   }
// }
