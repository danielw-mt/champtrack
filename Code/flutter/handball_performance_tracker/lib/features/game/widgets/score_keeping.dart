// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:handball_performance_tracker/core/constants/colors.dart';
// import 'package:handball_performance_tracker/core/constants/stringsGeneral.dart';
// import 'package:handball_performance_tracker/oldcontrollers/persistent_controller.dart';
// import 'package:handball_performance_tracker/oldcontrollers/temp_controller.dart';
// import '../../../../old-widgets/main_screen/ef_score_bar.dart';

// class ScoreKeeping extends StatelessWidget {
//   const ScoreKeeping({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final TempController tempController = Get.find<TempController>();
// final PersistentController persController =
//         Get.find<PersistentController>();
//     return Container(
//       margin: EdgeInsets.only(left: 30),
//       decoration: BoxDecoration(
//           color: buttonGreyColor,
//           // set border so corners can be made round
//           border: Border.all(
//             color: buttonGreyColor,
//           ),
//           // make round edges
//           borderRadius: BorderRadius.all(Radius.circular(menuRadius))),
//       child: IntrinsicHeight(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Name of own team
//             Container(
//               alignment: Alignment.center,
//               padding: const EdgeInsets.only(left: 5.0),
//               child: Text(
//                 tempController.getSelectedTeam().name,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             // Scores
//             TextButton(
//               onPressed: () => callScoreKeeping(context),
//               child:
//                   // Container with Scores
//                   Container(
//                 padding: const EdgeInsets.all(10.0),
//                 alignment: Alignment.center,
//                 color: Colors.white,
//                 child: GetBuilder<TempController>(
//                     id: "score-keeping",
//                     builder: (tempController) {
//                       return Text(
//                         tempController.getOwnScore().toString() +
//                             " : " +
//                             tempController.getOpponentScore().toString(),
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20,
//                             color: Colors.black),
//                       );
//                     }),
//               ),
//             ),
//             // Name of opponent team
//             Container(
//                 alignment: Alignment.center,
//                 padding: const EdgeInsets.only(right: 5.0),
//                 child: Text(
//                   persController.getCurrentGame().opponent!,
//                   textAlign: TextAlign.center,
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void callScoreKeeping(context) {
//   final TempController tempController = Get.find<TempController>();
//   double buttonHeight = MediaQuery.of(context).size.height * 0.1;

//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           scrollable: true,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(menuRadius),
//           ),
//           content:
//               // Column of "Edit score", horizontal line and score
//               Column(
//             children: [
//               // upper row: Text "Edit score"
//               const Align(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   StringsGeneral.lEditScore,
//                   textAlign: TextAlign.left,
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//               // horizontal line
//               const Divider(
//                 thickness: 2,
//                 color: Colors.black,
//                 height: 6,
//               ),
//               Text(""),

//               IntrinsicHeight(
//                 child: Row(
//                   children: [
//                     // Name of own team
//                     Container(
//                         margin: EdgeInsets.only(
//                             top: buttonHeight, bottom: buttonHeight),
//                         decoration: BoxDecoration(
//                           color: buttonGreyColor,
//                           // set border so corners can be made round
//                           border: Border.all(
//                             color: buttonGreyColor,
//                           ),
//                           // make round edges
//                           borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(menuRadius),
//                               topLeft: Radius.circular(menuRadius)),
//                         ),
//                         alignment: Alignment.center,
//                         padding: const EdgeInsets.all(5.0),
//                         child: Text(
//                           tempController.getSelectedTeam().name,
//                           textAlign: TextAlign.center,
//                         )),
//                     Column(
//                       children: [
//                         // Plus button of own team
//                         SizedBox(
//                           height: buttonHeight,
//                           child: TextButton(
//                             style: TextButton.styleFrom(
//                               backgroundColor: buttonLightBlueColor,
//                             ),
//                             onPressed: () {
//                               tempController.incOwnScore();
//                             },
//                             child:
//                                 Icon(Icons.add, size: 15, color: Colors.black),
//                           ),
//                         ),
//                         // Container with Score
//                         GetBuilder<TempController>(
//                             id: "score-keeping-own",
//                             builder: (tempController) {
//                               return Container(
//                                   height: buttonHeight * 1.3,
//                                   width: buttonHeight,
//                                   margin: EdgeInsets.only(left: 5, right: 5),
//                                   padding: const EdgeInsets.all(10.0),
//                                   alignment: Alignment.center,
//                                   color: Colors.white,
//                                   child: TextField(
//                                     onChanged: (text) => tempController
//                                         .setOwnScore(int.parse(text)),
//                                     textAlign: TextAlign.center,
//                                     decoration: InputDecoration(
//                                         border: InputBorder.none,
//                                         hintText: tempController
//                                             .getOwnScore()
//                                             .toString()),
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 28),
//                                   ));
//                             }),
//                         // Minus buttons of own team
//                         SizedBox(
//                           height: buttonHeight,
//                           child: TextButton(
//                             style: TextButton.styleFrom(
//                               backgroundColor: buttonLightBlueColor,
//                             ),
//                             onPressed: () {
//                               tempController.decOwnScore();
//                             },
//                             child: Icon(Icons.remove,
//                                 size: 15, color: Colors.black),
//                           ),
//                         ),
//                       ],
//                     ),
//                     // Vertical line between score
//                     VerticalDivider(
//                       color: Colors.black,
//                       endIndent: buttonHeight,
//                       indent: buttonHeight,
//                     ),
//                     Column(children: [
//                       // Plus button of opponent team
//                       SizedBox(
//                         height: buttonHeight,
//                         child: TextButton(
//                           style: TextButton.styleFrom(
//                             backgroundColor: buttonLightBlueColor,
//                           ),
//                           onPressed: () {
//                             tempController.incOpponentScore();
//                           },
//                           child: Icon(Icons.add, size: 15, color: Colors.black),
//                         ),
//                       ),
//                       // Container with Score

//                       GetBuilder<TempController>(
//                           id: "score-keeping-opponent",
//                           builder: (tempController) {
//                             return Container(
//                                 height: buttonHeight * 1.3,
//                                 width: buttonHeight,
//                                 margin: EdgeInsets.only(left: 5, right: 5),
//                                 padding: const EdgeInsets.all(10.0),
//                                 alignment: Alignment.center,
//                                 color: Colors.white,
//                                 child: TextField(
//                                   onChanged: (text) => tempController
//                                       .setOpponentScore(int.parse(text)),
//                                   textAlign: TextAlign.center,
//                                   decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       hintText: tempController
//                                           .getOpponentScore()
//                                           .toString()),
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 28),
//                                 ));
//                           }),
//                       // minus button of opponent team
//                       SizedBox(
//                         height: buttonHeight,
//                         child: TextButton(
//                           style: TextButton.styleFrom(
//                             backgroundColor: buttonLightBlueColor,
//                           ),
//                           onPressed: () {
//                             tempController.decOpponentScore();
//                           },
//                           child:
//                               Icon(Icons.remove, size: 15, color: Colors.black),
//                         ),
//                       )
//                     ]),

//                     // Name of opponent team
//                     Container(
//                         margin: EdgeInsets.only(
//                             top: buttonHeight, bottom: buttonHeight),
//                         decoration: BoxDecoration(
//                             color: buttonGreyColor,
//                             // set border so corners can be made round
//                             border: Border.all(
//                               color: buttonGreyColor,
//                             ),
//                             // make round edges
//                             borderRadius: BorderRadius.only(
//                                 bottomRight: Radius.circular(menuRadius),
//                                 topRight: Radius.circular(menuRadius))),
//                         alignment: Alignment.center,
//                         padding: const EdgeInsets.all(5.0),
//                         child: Text(
//                           StringsGeneral.lOpponent,
//                           textAlign: TextAlign.center,
//                         )),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       });
// }
