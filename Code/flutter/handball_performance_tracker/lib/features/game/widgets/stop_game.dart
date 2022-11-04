// import 'package:flutter/material.dart';
// import 'package:handball_performance_tracker/core/constants/colors.dart';
// import 'package:handball_performance_tracker/core/constants/stringsGameScreen.dart';
// import 'package:handball_performance_tracker/core/constants/stringsGameSettings.dart';
// import 'package:get/get.dart';
// import 'package:handball_performance_tracker/old-screens/dashboard.dart';
// import 'package:handball_performance_tracker/old-utils/game_control.dart';

// class StopGameButton extends StatelessWidget {
//   const StopGameButton({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(right: 3),
//       child: TextButton(
//           style: TextButton.styleFrom(
//             backgroundColor: buttonDarkBlueColor,
//             primary: Colors.black,
//           ),
//           onPressed: () {
//             showDialog<String>(
//               context: context,
//               builder: (BuildContext context) => AlertDialog(
//                 title: const Text(StringsGameScreen.lStopGame),
//                 actions: <Widget>[
//                   TextButton(
//                     onPressed: () => Navigator.pop(
//                         context, StringsGameSettings.lCancelButton),
//                     child: Text(
//                       StringsGameSettings.lCancelButton,
//                       style: TextStyle(
//                         color: buttonDarkBlueColor,
//                       ),
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       stopGame();
//                       Get.to(Dashboard());
//                     },
//                     child: Text(
//                       'OK',
//                       style: TextStyle(
//                         color: buttonDarkBlueColor,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//           child: Row(
//             children: [
//               Icon(
//                 Icons.exit_to_app,
//                 color: Colors.white,
//               ),
//               Text(
//                 StringsGameScreen.lStopGame,
//                 style: TextStyle(
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           )),
//     );
//   }
// }
