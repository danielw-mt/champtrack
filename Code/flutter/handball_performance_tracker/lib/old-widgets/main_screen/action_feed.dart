// import 'package:flutter/material.dart';
// import 'package:handball_performance_tracker/core/constants/colors.dart';
// import 'package:handball_performance_tracker/core/constants/stringsGameScreen.dart';
// import 'package:handball_performance_tracker/core/constants/stringsGeneral.dart';
// import '../../../../old-widgets/main_screen/ef_score_bar.dart';
// import 'package:handball_performance_tracker/core/constants/fieldSizeParameter.dart' as fieldSizeParameter;
// import '../../oldcontrollers/temp_controller.dart';
// import 'package:handball_performance_tracker/core/constants/fieldSizeParameter.dart' as fieldSizeParameter;
// import '../../oldcontrollers/temp_controller.dart';
// import 'package:get/get.dart';
// import '../../data/models/game_action_model.dart';
// import '../../data/models/player_model.dart';
// import '../../old-utils/feed_logic.dart';

// /// A widget that displays the newest actions. It can be tweaked in lib/const/settings_config
// /// GameActions are periodically removed and can also be removed by clicking on them
// class ActionFeed extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<TempController>(
//       id: "action-feed",
//       builder: (tempController) {
//         List<GameAction> feedActions = tempController.getFeedActions();
//         return Container(
//           margin: EdgeInsets.only(left: 10),
//           padding: EdgeInsets.only(bottom: 5),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(bottomLeft: Radius.circular(menuRadius), bottomRight: Radius.circular(menuRadius))),
//           alignment: Alignment.centerLeft,
//           width: MediaQuery.of(context).size.width * 0.23,
//           height: fieldSizeParameter.fieldHeight * 0.95,
//           child: Column(
//             children: [
//               FeedHeader(),
//               Expanded(
//                 child: ListView.builder(
//                     controller: ScrollController(),
//                     physics: ClampingScrollPhysics(),
//                     reverse: true,
//                     shrinkWrap: true,
//                     itemCount: feedActions.length,
//                     itemBuilder: (context, index) {
//                       GameAction feedAction = feedActions.reversed.toList()[index];
//                       String actionTag = feedAction.tag;
//                       Player relevantPlayer = Player();
//                       // get the player object whose id matches the playerId in the action Object
//                       if (feedAction.playerId != "opponent") {
//                         relevantPlayer = tempController.getPlayerFromSelectedTeam(feedAction.playerId);
//                       } else {
//                         relevantPlayer = Player(lastName: StringsGameScreen.lOpponent, id: "opponent");
//                       }
//                       return Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Container(
//                                 margin: EdgeInsets.only(left: 5),
//                                 width: buttonHeight * 0.8,
//                                 height: buttonHeight * 0.8,
//                                 decoration: BoxDecoration(color: buttonGreyColor, borderRadius: BorderRadius.all(Radius.circular(menuRadius))),
//                                 child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                                   Flexible(
//                                     child: Text(
//                                       actionTag,
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                   ),
//                                 ]),
//                               ),
//                               Expanded(
//                                 child: Container(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(
//                                     relevantPlayer == Player() ? StringsGameScreen.lUnknown : relevantPlayer.lastName,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                       fontSize: 15,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               MouseRegion(
//                                 cursor: SystemMouseCursors.click,
//                                 child: GestureDetector(
//                                   onTap: () async {
//                                     removeFeedItem(feedAction, tempController);
//                                   },
//                                   child: Icon(
//                                     Icons.delete,
//                                     size: 30,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                           if (index != feedActions.length) Divider()
//                         ],
//                       );
//                     }),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class FeedHeader extends StatelessWidget {
//   const FeedHeader({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//           color: buttonDarkBlueColor,
//           // set border so corners can be made round
//           border: Border.all(
//             color: buttonDarkBlueColor,
//           ),
//           // make round edges
//           borderRadius: BorderRadius.only(topLeft: Radius.circular(menuRadius), topRight: Radius.circular(menuRadius))),
//       padding: EdgeInsets.all(10),
//       margin: EdgeInsets.only(bottom: 5),
//       child: Text(StringsGeneral.lFeedHeader, style: TextStyle(color: Colors.white)),
//     );
//   }
// }
