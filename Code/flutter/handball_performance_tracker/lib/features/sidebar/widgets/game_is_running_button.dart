import 'package:flutter/material.dart';

// Button which takes you back to the game
// class GameIsRunningButton extends StatelessWidget {
//   const GameIsRunningButton({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final TempController tempController = Get.find<TempController>();

//     // Back to Game Button
//     return Container(
//       decoration: BoxDecoration(
//           color: buttonDarkBlueColor,
//           // set border so corners can be made round
//           border: Border.all(
//             color: buttonDarkBlueColor,
//           ),
//           // make round edges
//           borderRadius: BorderRadius.all(Radius.circular(menuRadius))),
//       margin: EdgeInsets.only(left: 20, right: 20, top: 100),
//       padding: EdgeInsets.all(10),
//       child: TextButton(
//         style: TextButton.styleFrom(
//           backgroundColor: buttonGreyColor,
//           padding: EdgeInsets.all(20),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(
//               Radius.circular(buttonRadius),
//             ),
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.sports_handball, color: buttonDarkBlueColor, size: 50),
//             Expanded(
//               child: Text(
//                 StringsGeneral.lBackToGameButton,
//                 style: TextStyle(color: buttonDarkBlueColor, fontSize: 18),
//               ),
//             )
//           ],
//         ),
//         onPressed: () {
//           tempController.setSelectedTeam(tempController.getPlayingTeam());
//           Navigator.pop(context);
//           Get.to(MainScreen());
//         },
//       ),
//     );
//   }
// }