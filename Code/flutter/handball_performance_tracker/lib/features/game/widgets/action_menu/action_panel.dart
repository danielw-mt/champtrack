import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/constants/stringsGameScreen.dart';
import 'package:handball_performance_tracker/core/constants/game_actions.dart';
import 'action_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'goal_keeper_buttons.dart';
import 'defense_buttons.dart';
import 'attack_buttons.dart';

/// A menu of differently arranged buttons depending on whether we are in action, defense or goal keeper mode
class ActionPanel extends StatelessWidget {
  final String actionContext;
  ActionPanel({super.key, required this.actionContext});
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(thumbVisibility: true, controller: pageController, child: PageView(controller: pageController, children: buildPages()));
  }

  // a method for building the children of the pageview in the right order
  // by arranging either the attack menu or defense menu first or the goal keeper menu
  List<Widget> buildPages() {
    print("building page view children");
    if (actionContext == actionContextGoalkeeper) {
      return [GoalKeeperButtons()];
    } else if (actionContext == actionContextAttack) {
      print("action state attack");
      return [
        AttackButtons(),
        DefenseButtons(),
      ];
    } else if (actionContext == actionContextDefense) {
      return [
        DefenseButtons(),
        AttackButtons(),
      ];
    } else {
      print("no page view children");
      return [Text("Could not build menu that is matching the phase of the game")];
    }
  }
}

// TODO delete this
// class ArrangedDialogButtons extends StatelessWidget {
//   final String actionContext;
//   const ArrangedDialogButtons({super.key, required this.actionContext});

//   @override
//   Widget build(BuildContext context) {
//     final GameBloc gameBloc = context.watch<GameBloc>();
//     print("building arranged dialog buttons");
//     return Column(children: [
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Align(
//             alignment: Alignment.topLeft,
//             // header text of menu
//             child: Text(
//               (() {
//                 if (actionContext == actionContextAttack) {
//                   return StringsGameScreen.lOffensePopUpHeader;
//                 } else if (actionContext == actionContextGoalkeeper) {
//                   return StringsGameScreen.lGoalkeeperPopUpHeader;
//                 } else if (actionContext == actionContextDefense) {
//                   return StringsGameScreen.lDefensePopUpHeader;
//                 } else {
//                   return "Error";
//                 }
//               })(),
//               textAlign: TextAlign.left,
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 20,
//               ),
//             ),
//           ),
//           Align(
//               alignment: Alignment.topRight,
//               // Change from "" to "Assist" after a goal.
//               child: Text(
//                 gameBloc.state.actionMenuHintText,
//                 textAlign: TextAlign.right,
//                 style: const TextStyle(
//                   color: Colors.purple,
//                   fontSize: 20,
//                 ),
//               )),
//         ],
//       ),
//       // horizontal line
//       const Divider(
//         thickness: 2,
//         color: Colors.black,
//         height: 6,
//       ),
//       // Button-Row: one Row with 3 Columns of 3, 2 and 2 buttons
//       Expanded(child: arrangeDialogButtons(context))
//     ]);
//   }

//   Row arrangeDialogButtons(BuildContext context) {
//     print("arranging dialog buttons");
//     // String header;
//     Row buttonRow;
//     Map<String, ActionButton> dialogButtons = buildDialogButtons(context);
//     if (actionContext == actionContextGoalkeeper) {
//       buttonRow = Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//         Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//           Flexible(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 dialogButtons[StringsGameScreen.lYellowCard]!,
//                 dialogButtons[StringsGameScreen.lRedCard]!,
//               ],
//             ),
//           ),
//           Flexible(child: dialogButtons[StringsGameScreen.lTimePenalty]!),
//           Flexible(child: dialogButtons[StringsGameScreen.lEmptyGoal]!),
//           Flexible(child: dialogButtons[StringsGameScreen.lErrThrowGoalkeeper]!),
//         ]),
//         Flexible(
//           child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//             Flexible(child: dialogButtons[StringsGameScreen.lGoalGoalkeeper]!),
//             Flexible(child: dialogButtons[StringsGameScreen.lBadPass]!),
//           ]),
//         ),
//         Flexible(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Flexible(child: dialogButtons[StringsGameScreen.lParade]!),
//               Flexible(child: dialogButtons[StringsGameScreen.lGoalOpponent]!),
//             ],
//           ),
//         ),
//       ]);
//     } else if (actionContext == actionContextAttack) {
//       buttonRow = Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//         Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//           Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [dialogButtons[StringsGameScreen.lYellowCard]!, dialogButtons[StringsGameScreen.lRedCard]!]),
//           Flexible(child: dialogButtons[StringsGameScreen.lTwoMin]!),
//           Flexible(child: dialogButtons[StringsGameScreen.lTimePenalty]!),
//         ]),
//         Flexible(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [Flexible(child: dialogButtons[StringsGameScreen.lErrThrow]!), Flexible(child: dialogButtons[StringsGameScreen.lTrf]!)],
//           ),
//         ),
//         Flexible(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [Flexible(child: dialogButtons[StringsGameScreen.lGoal]!), Flexible(child: dialogButtons[StringsGameScreen.lOneVsOneAnd7m]!)],
//           ),
//         ),
//       ]);
//     } else {
//       buttonRow = Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//         Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Row(children: [dialogButtons[StringsGameScreen.lYellowCard]!, dialogButtons[StringsGameScreen.lRedCard]!]),
//             Flexible(child: dialogButtons[StringsGameScreen.lTwoMin]!),
//             Flexible(child: dialogButtons[StringsGameScreen.lTimePenalty]!)
//           ],
//         ),
//         Flexible(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [Flexible(child: dialogButtons[StringsGameScreen.lFoul7m]!), Flexible(child: dialogButtons[StringsGameScreen.lTrf]!)],
//           ),
//         ),
//         Flexible(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Flexible(child: dialogButtons[StringsGameScreen.lBlockNoBall]!),
//               Flexible(child: dialogButtons[StringsGameScreen.lBlockAndSteal]!)
//             ],
//           ),
//         ),
//       ]);
//     }
//     return buttonRow;
//   }

//   // TODO clean up actionTag calls
//   Map<String, ActionButton> buildDialogButtons(BuildContext context) {
//     print("building dialog buttons");
//     if (actionContext == actionContextGoalkeeper) {
//       Map<String, String> goalKeeperActionMapping = actionMapping[actionContextGoalkeeper]!;
//       return {
//         StringsGameScreen.lRedCard: ActionButton(
//             buildContext: context,
//             actionTag: goalKeeperActionMapping[StringsGameScreen.lRedCard]!,
//             actionContext: actionContextGoalkeeper,
//             buttonText: StringsGameScreen.lRedCard,
//             buttonColor: Colors.red,
//             sizeFactor: 0,
//             icon: Icon(Icons.style)),
//         StringsGameScreen.lYellowCard: ActionButton(
//             buildContext: context,
//             actionTag: goalKeeperActionMapping[StringsGameScreen.lYellowCard]!,
//             actionContext: actionContextGoalkeeper,
//             buttonText: StringsGameScreen.lYellowCard,
//             buttonColor: Colors.yellow,
//             sizeFactor: 0,
//             icon: Icon(Icons.style)),
//         StringsGameScreen.lTimePenalty: ActionButton(
//             buildContext: context,
//             actionTag: goalKeeperActionMapping[StringsGameScreen.lTimePenalty]!,
//             actionContext: actionContextGoalkeeper,
//             buttonText: StringsGameScreen.lTimePenalty,
//             buttonColor: Color.fromRGBO(199, 208, 244, 1),
//             sizeFactor: 2,
//             icon: Icon(Icons.timer)),
//         StringsGameScreen.lEmptyGoal: ActionButton(
//           buildContext: context,
//           actionTag: goalKeeperActionMapping[StringsGameScreen.lEmptyGoal]!,
//           actionContext: actionContextGoalkeeper,
//           buttonText: StringsGameScreen.lEmptyGoal,
//           buttonColor: Color.fromRGBO(199, 208, 244, 1),
//           sizeFactor: 2,
//         ),
//         StringsGameScreen.lErrThrowGoalkeeper: ActionButton(
//           buildContext: context,
//           actionTag: goalKeeperActionMapping[StringsGameScreen.lErrThrowGoalkeeper]!,
//           actionContext: actionContextGoalkeeper,
//           buttonText: StringsGameScreen.lErrThrowGoalkeeper,
//           buttonColor: Color.fromRGBO(199, 208, 244, 1),
//           sizeFactor: 2,
//         ),
//         StringsGameScreen.lGoalGoalkeeper: ActionButton(
//           buildContext: context,
//           actionTag: goalKeeperActionMapping[StringsGameScreen.lGoalGoalkeeper]!,
//           actionContext: actionContextGoalkeeper,
//           buttonText: StringsGameScreen.lGoalGoalkeeper,
//           buttonColor: Color.fromRGBO(99, 107, 171, 1),
//         ),
//         StringsGameScreen.lBadPass: ActionButton(
//           buildContext: context,
//           actionTag: goalKeeperActionMapping[StringsGameScreen.lBadPass]!,
//           actionContext: actionContextGoalkeeper,
//           buttonText: StringsGameScreen.lBadPass,
//           buttonColor: Color.fromRGBO(203, 206, 227, 1),
//         ),
//         StringsGameScreen.lParade: ActionButton(
//           buildContext: context,
//           actionTag: goalKeeperActionMapping[StringsGameScreen.lParade]!,
//           actionContext: actionContextGoalkeeper,
//           buttonText: StringsGameScreen.lParade,
//           buttonColor: Color.fromRGBO(99, 107, 171, 1),
//         ),
//         StringsGameScreen.lGoalOpponent: ActionButton(
//           buildContext: context,
//           actionTag: goalKeeperActionMapping[StringsGameScreen.lGoalOpponent]!,
//           actionContext: actionContextGoalkeeper,
//           buttonText: StringsGameScreen.lGoalOpponent,
//           buttonColor: Color.fromRGBO(203, 206, 227, 1),
//         ),
//       };
//     }
//     if (actionContext == actionContextAttack) {
//       Map<String, String> attackActionMapping = actionMapping[actionContextAttack]!;
//       return {
//         StringsGameScreen.lRedCard: ActionButton(
//             buildContext: context,
//             actionTag: attackActionMapping[StringsGameScreen.lRedCard]!,
//             actionContext: actionContextAttack,
//             buttonText: StringsGameScreen.lRedCard,
//             buttonColor: Colors.red,
//             sizeFactor: 0,
//             icon: Icon(Icons.style)),
//         StringsGameScreen.lYellowCard: ActionButton(
//             buildContext: context,
//             actionTag: attackActionMapping[StringsGameScreen.lYellowCard]!,
//             actionContext: actionContextAttack,
//             buttonText: StringsGameScreen.lYellowCard,
//             buttonColor: Colors.yellow,
//             sizeFactor: 0,
//             icon: Icon(Icons.style)),
//         StringsGameScreen.lTimePenalty: ActionButton(
//           buildContext: context,
//           actionTag: attackActionMapping[StringsGameScreen.lTimePenalty]!,
//           actionContext: actionContextAttack,
//           buttonText: StringsGameScreen.lTimePenalty,
//           buttonColor: Color.fromRGBO(199, 208, 244, 1),
//           sizeFactor: 1,
//         ),
//         StringsGameScreen.lGoal: ActionButton(
//           buildContext: context,
//           actionTag: attackActionMapping[StringsGameScreen.lGoal]!,
//           actionContext: actionContextAttack,
//           buttonText: StringsGameScreen.lGoal,
//           buttonColor: Color.fromRGBO(99, 107, 171, 1),
//         ),
//         StringsGameScreen.lOneVsOneAnd7m: ActionButton(
//           buildContext: context,
//           actionTag: attackActionMapping[StringsGameScreen.lOneVsOneAnd7m]!,
//           actionContext: actionContextAttack,
//           buttonText: StringsGameScreen.lOneVsOneAnd7m,
//           buttonColor: Color.fromRGBO(99, 107, 171, 1),
//         ),
//         StringsGameScreen.lTwoMin: ActionButton(
//           buildContext: context,
//           actionTag: attackActionMapping[StringsGameScreen.lTwoMin]!,
//           actionContext: actionContextAttack,
//           buttonText: StringsGameScreen.lTwoMin,
//           buttonColor: Color.fromRGBO(199, 208, 244, 1),
//           sizeFactor: 1,
//         ),
//         StringsGameScreen.lErrThrow: ActionButton(
//           buildContext: context,
//           actionTag: attackActionMapping[StringsGameScreen.lErrThrow]!,
//           actionContext: actionContextAttack,
//           buttonText: StringsGameScreen.lErrThrow,
//           buttonColor: Color.fromRGBO(203, 206, 227, 1),
//         ),
//         StringsGameScreen.lTrf: ActionButton(
//           buildContext: context,
//           actionTag: attackActionMapping[StringsGameScreen.lTrf]!,
//           actionContext: actionContextAttack,
//           buttonText: StringsGameScreen.lTrf,
//           buttonColor: Color.fromRGBO(203, 206, 227, 1),
//         ),
//       };
//     }
//     if (actionContext == actionContextDefense) {
//       // tags action tags for the different buttons
//       Map<String, String> defenseActionMapping = actionMapping[actionContextDefense]!;
//       return {
//         StringsGameScreen.lRedCard: ActionButton(
//             buildContext: context,
//             actionTag: defenseActionMapping[StringsGameScreen.lRedCard]!,
//             actionContext: actionContextDefense,
//             buttonText: StringsGameScreen.lRedCard,
//             buttonColor: Colors.red,
//             sizeFactor: 0,
//             icon: Icon(Icons.style)),
//         StringsGameScreen.lYellowCard: ActionButton(
//             buildContext: context,
//             actionTag: defenseActionMapping[StringsGameScreen.lYellowCard]!,
//             actionContext: actionContextDefense,
//             buttonText: StringsGameScreen.lYellowCard,
//             buttonColor: Colors.yellow,
//             sizeFactor: 0,
//             icon: Icon(Icons.style)),
//         StringsGameScreen.lFoul7m: ActionButton(
//           buildContext: context,
//           actionTag: defenseActionMapping[StringsGameScreen.lFoul7m]!,
//           actionContext: actionContextDefense,
//           buttonText: StringsGameScreen.lFoul7m,
//           buttonColor: Color.fromRGBO(203, 206, 227, 1),
//         ),
//         StringsGameScreen.lTimePenalty: ActionButton(
//             buildContext: context,
//             actionTag: defenseActionMapping[StringsGameScreen.lTimePenalty]!,
//             actionContext: actionContextDefense,
//             buttonText: StringsGameScreen.lTimePenalty,
//             buttonColor: Color.fromRGBO(199, 208, 244, 1),
//             sizeFactor: 1,
//             icon: Icon(Icons.timer)),
//         StringsGameScreen.lBlockNoBall: ActionButton(
//           buildContext: context,
//           actionTag: defenseActionMapping[StringsGameScreen.lBlockNoBall]!,
//           actionContext: actionContextDefense,
//           buttonText: StringsGameScreen.lBlockNoBall,
//           buttonColor: Color.fromRGBO(99, 107, 171, 1),
//         ),
//         StringsGameScreen.lBlockAndSteal: ActionButton(
//           buildContext: context,
//           actionTag: defenseActionMapping[StringsGameScreen.lBlockAndSteal]!,
//           actionContext: actionContextDefense,
//           buttonText: StringsGameScreen.lBlockAndSteal,
//           buttonColor: Color.fromRGBO(99, 107, 171, 1),
//         ),
//         StringsGameScreen.lTrf: ActionButton(
//           buildContext: context,
//           actionTag: defenseActionMapping[StringsGameScreen.lTrf]!,
//           actionContext: actionContextDefense,
//           buttonText: StringsGameScreen.lTrf,
//           buttonColor: Color.fromRGBO(203, 206, 227, 1),
//         ),
//         StringsGameScreen.lTwoMin: ActionButton(
//           buildContext: context,
//           actionTag: defenseActionMapping[StringsGameScreen.lTwoMin]!,
//           actionContext: actionContextDefense,
//           buttonText: StringsGameScreen.lTwoMin,
//           buttonColor: Color.fromRGBO(199, 208, 244, 1),
//           sizeFactor: 1,
//         ),
//       };
//     }
//     return {};
//   }
// }
