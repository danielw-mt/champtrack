import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/data/player.dart';
import 'package:handball_performance_tracker/utils/feed_logic.dart';
import 'package:handball_performance_tracker/utils/player_helper.dart';
import 'package:handball_performance_tracker/widgets/helper_screen/alert_message_widget.dart';
import 'package:handball_performance_tracker/widgets/main_screen/action_menu/action_menu.dart';
import 'package:handball_performance_tracker/widgets/main_screen/ef_score_bar.dart';
import 'package:handball_performance_tracker/widgets/main_screen/field.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../../../constants/stringsGameScreen.dart';
import '../../../controllers/persistentController.dart';
import '../../../controllers/tempController.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../../data/game_action.dart';
import '../../../constants/game_actions.dart';
import '../playermenu.dart';
import 'dart:math';
import 'package:logger/logger.dart';
import 'dialog_button.dart';

var logger = Logger(
  printer: PrettyPrinter(
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: false // Should each log print contain a timestamp
      ),
);


/// A menu of differently arranged buttons depending on whether we are in action, defense or goal keeper mode
class DialogButtonMenu extends StatelessWidget {
  final String actionState;
  DialogButtonMenu({super.key, required this.actionState});

  @override
  Widget build(BuildContext context) {
    return PageView(
        controller: new PageController(), children: buildPageViewChildren());
  }

  // a method for building the children of the pageview in the right order
  // by arranging either the attack menu or defense menu first or the goal keeper menu
  List<Widget> buildPageViewChildren() {
    print("building page view children");
    if (actionState == actionStateGoalkeeper) {
      return [ArrangedDialogButtons(actionState: actionState)];
    } else if (actionState == actionStateAttack) {
      print("action state attack");
      return [
        ArrangedDialogButtons(actionState: actionStateAttack),
        ArrangedDialogButtons(actionState: actionStateDefense),
      ];
    } else if (actionState == actionStateDefense) {
      return [
        ArrangedDialogButtons(actionState: actionStateDefense),
        ArrangedDialogButtons(actionState: actionStateAttack),
      ];
    } else {
      print("no page view children");
      return [
        Text("Could not build menu that is matching the phase of the game")
      ];
    }
  }
}

class ArrangedDialogButtons extends StatelessWidget {
  final String actionState;
  const ArrangedDialogButtons({super.key, required this.actionState});

  @override
  Widget build(BuildContext context) {
    print("building arranged dialog buttons");
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topLeft,
            // header text of menu
            child: Text(
              (() {
                if (actionState == actionStateAttack) {
                  return StringsGameScreen.lOffensePopUpHeader;
                } else if (actionState == actionStateGoalkeeper) {
                  return StringsGameScreen.lGoalkeeperPopUpHeader;
                } else if (actionState == actionStateDefense) {
                  return StringsGameScreen.lDefensePopUpHeader;
                } else {
                  return "Error";
                }
              })(),
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            // Change from "" to "Assist" after a goal.
            child: GetBuilder<TempController>(
                id: "action-menu-text",
                builder: (tempController) {
                  return Text(
                    tempController.getActionMenuText(),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.purple,
                      fontSize: 20,
                    ),
                  );
                }),
          ),
        ],
      ),
      // horizontal line
      const Divider(
        thickness: 2,
        color: Colors.black,
        height: 6,
      ),
      // Button-Row: one Row with 3 Columns of 3, 2 and 2 buttons
      Expanded(child: arrangeDialogButtons(context))
    ]);
  }

  Row arrangeDialogButtons(BuildContext context) {
    print("arranging dialog buttons");
    // String header;
    Row buttonRow;
    Map<String, CustomDialogButton> dialogButtons =
          buildDialogButtons(context);
    if (actionState == actionStateGoalkeeper) {
      buttonRow = Row(children: [
        Column(children: [
          Flexible(
            child: Row(
              children: [
                dialogButtons[StringsGameScreen.lYellowCard]!,
                dialogButtons[StringsGameScreen.lRedCard]!,
                dialogButtons[StringsGameScreen.lTimePenalty]!,
              ],
            ),
          ),
          Flexible(child: dialogButtons[StringsGameScreen.lEmptyGoal]!),
          Flexible(
              child: dialogButtons[StringsGameScreen.lErrThrowGoalkeeper]!),
        ]),
        Flexible(
          child: Column(children: [
            Flexible(child: dialogButtons[StringsGameScreen.lGoalGoalkeeper]!),
            Flexible(child: dialogButtons[StringsGameScreen.lBadPass]!),
          ]),
        ),
        Flexible(
          child: Column(
            children: [
              Flexible(child: dialogButtons[StringsGameScreen.lParade]!),
              Flexible(child: dialogButtons[StringsGameScreen.lGoalOtherSide]!),
            ],
          ),
        ),
      ]);
    } else if (actionState == actionStateAttack) {
      logger.d("arranging dialog buttons for attack");
      buttonRow =
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Column(children: [
          Row(children: [dialogButtons[StringsGameScreen.lYellowCard]!, dialogButtons[StringsGameScreen.lRedCard]!]),
          Flexible(child: dialogButtons[StringsGameScreen.lTwoMin]!),
          Flexible(child: dialogButtons[StringsGameScreen.lTimePenalty]!),
        ]),
        Flexible(
          child: Column(
            children: [
              Flexible(child: dialogButtons[StringsGameScreen.lErrThrow]!),
              Flexible(child: dialogButtons[StringsGameScreen.lTrf]!)
            ],
          ),
        ),
        Flexible(
          child: Column(
            children: [
              Flexible(child: dialogButtons[StringsGameScreen.lGoal]!),
              Flexible(child: dialogButtons[StringsGameScreen.lOneVsOneAnd7m]!)
            ],
          ),
        ),
      ]);
    } else {
      buttonRow =
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Column(
          children: [
            Row(children: [dialogButtons[StringsGameScreen.lYellowCard]!, dialogButtons[StringsGameScreen.lRedCard]!]),
            Flexible(child: dialogButtons[StringsGameScreen.lTwoMin]!),
            Flexible(child: dialogButtons[StringsGameScreen.lTimePenalty]!)
          ],
        ),
        Flexible(
          child: Column(
            children: [
              Flexible(child: dialogButtons[StringsGameScreen.lFoul7m]!),
              Flexible(child: dialogButtons[StringsGameScreen.lTrf]!)
            ],
          ),
        ),
        Flexible(
          child: Column(
            children: [
              Flexible(child: dialogButtons[StringsGameScreen.lBlockNoBall]!),
              Flexible(child: dialogButtons[StringsGameScreen.lBlockAndSteal]!)
            ],
          ),
        ),
      ]);
    }
    return buttonRow;
  }

  // TODO adapt icons
  Map<String, CustomDialogButton> buildDialogButtons(BuildContext context) {
    print("building dialog buttons");
    if (actionState == actionStateGoalkeeper) {
      Map<String, String> goalKeeperActionMapping =
          actionMapping[actionStateGoalkeeper]!;
      return {
        StringsGameScreen.lRedCard: CustomDialogButton(
            context: context,
            actionTag: goalKeeperActionMapping[StringsGameScreen.lRedCard]!,
            buttonText: StringsGameScreen.lRedCard,
            buttonColor: Colors.red,
            sizeFactor: 0,
            icon: Icon(Icons.remove_circle_outline)),
        StringsGameScreen.lYellowCard: CustomDialogButton(
            context: context,
            actionTag: goalKeeperActionMapping[StringsGameScreen.lYellowCard]!,
            buttonText: StringsGameScreen.lYellowCard,
            buttonColor: Colors.yellow,
            sizeFactor: 0,
            icon: Icon(Icons.remove_circle_outline)),
        StringsGameScreen.lTimePenalty: CustomDialogButton(
            context: context,
            actionTag: goalKeeperActionMapping[StringsGameScreen.lTimePenalty]!,
            buttonText: StringsGameScreen.lTimePenalty,
            buttonColor: Color.fromRGBO(199, 208, 244, 1),
            sizeFactor: 0,
            icon: Icon(Icons.remove_circle_outline)),
        StringsGameScreen.lEmptyGoal: CustomDialogButton(
            context: context,
            actionTag: goalKeeperActionMapping[StringsGameScreen.lEmptyGoal]!,
            buttonText: StringsGameScreen.lEmptyGoal,
            buttonColor: Color.fromRGBO(199, 208, 244, 1),
            sizeFactor: 2,
            icon: Icon(Icons.remove_circle_outline)),
        StringsGameScreen.lErrThrowGoalkeeper: CustomDialogButton(
            context: context,
            actionTag:
                goalKeeperActionMapping[StringsGameScreen.lErrThrowGoalkeeper]!,
            buttonText: StringsGameScreen.lErrThrowGoalkeeper,
            buttonColor: Color.fromRGBO(199, 208, 244, 1),
            sizeFactor: 2,
            icon: Icon(Icons.remove_circle_outline)),
        StringsGameScreen.lGoalGoalkeeper: CustomDialogButton(
            context: context,
            actionTag:
                goalKeeperActionMapping[StringsGameScreen.lGoalGoalkeeper]!,
            buttonText: StringsGameScreen.lGoalGoalkeeper,
            buttonColor: Color.fromRGBO(99, 107, 171, 1),
            sizeFactor: 1,
            icon: Icon(Icons.remove_circle_outline)),
        StringsGameScreen.lBadPass: CustomDialogButton(
            context: context,
            actionTag: goalKeeperActionMapping[StringsGameScreen.lBadPass]!,
            buttonText: StringsGameScreen.lBadPass,
            buttonColor: Color.fromRGBO(203, 206, 227, 1),
            sizeFactor: 1,
            icon: Icon(Icons.remove_circle_outline)),
        StringsGameScreen.lParade: CustomDialogButton(
            context: context,
            actionTag: goalKeeperActionMapping[StringsGameScreen.lParade]!,
            buttonText: StringsGameScreen.lParade,
            buttonColor: Color.fromRGBO(99, 107, 171, 1),
            sizeFactor: 1,
            icon: Icon(Icons.remove_circle_outline)),
        StringsGameScreen.lGoalOtherSide: CustomDialogButton(
            context: context,
            actionTag:
                goalKeeperActionMapping[StringsGameScreen.lGoalOtherSide]!,
            buttonText: StringsGameScreen.lGoalOtherSide,
            buttonColor: Color.fromRGBO(203, 206, 227, 1),
            sizeFactor: 1,
            icon: Icon(Icons.remove_circle_outline)),
      };
    }
    if (actionState == actionStateAttack) {
      Map<String, String> attackActionMapping =
          actionMapping[actionStateAttack]!;
      logger.d("attackActionMapping: $attackActionMapping");
      return {
        StringsGameScreen.lRedCard: CustomDialogButton(
            context: context,
            actionTag: attackActionMapping[StringsGameScreen.lRedCard]!,
            buttonText: StringsGameScreen.lRedCard,
            buttonColor: Colors.red,
            sizeFactor: 0,
            icon: Icon(Icons.remove_circle_outline)),
        StringsGameScreen.lYellowCard: CustomDialogButton(
            context: context,
            actionTag: attackActionMapping[StringsGameScreen.lYellowCard]!,
            buttonText: StringsGameScreen.lYellowCard,
            buttonColor: Colors.yellow,
            sizeFactor: 0,
            icon: Icon(Icons.remove_circle_outline)),
        StringsGameScreen.lTimePenalty: CustomDialogButton(
            context: context,
            actionTag: attackActionMapping[StringsGameScreen.lTimePenalty]!,
            buttonText: StringsGameScreen.lTimePenalty,
            buttonColor: Color.fromRGBO(199, 208, 244, 1),
            sizeFactor: 1,
            icon: Icon(Icons.remove_circle_outline)),
        StringsGameScreen.lGoal: CustomDialogButton(
            context: context,
            actionTag: attackActionMapping[StringsGameScreen.lGoal]!,
            buttonText: StringsGameScreen.lGoal,
            buttonColor: Color.fromRGBO(99, 107, 171, 1),
            sizeFactor: 1,
            icon: Icon(Icons.remove_circle_outline)),
        StringsGameScreen.lOneVsOneAnd7m: CustomDialogButton(
            context: context,
            actionTag: attackActionMapping[StringsGameScreen.lOneVsOneAnd7m]!,
            buttonText: StringsGameScreen.lOneVsOneAnd7m,
            buttonColor: Color.fromRGBO(99, 107, 171, 1),
            sizeFactor: 1,
            icon: Icon(Icons.remove_circle_outline)),
        StringsGameScreen.lTwoMin: CustomDialogButton(
            context: context,
            actionTag: attackActionMapping[StringsGameScreen.lTwoMin]!,
            buttonText: StringsGameScreen.lTwoMin,
            buttonColor: Color.fromRGBO(199, 208, 244, 1),
            sizeFactor: 1,
            icon: Icon(Icons.remove_circle_outline)),
        StringsGameScreen.lErrThrow: CustomDialogButton(
            context: context,
            actionTag: attackActionMapping[StringsGameScreen.lErrThrow]!,
            buttonText: StringsGameScreen.lErrThrow,
            buttonColor: Color.fromRGBO(203, 206, 227, 1),
            icon: Icon(Icons.remove_circle_outline)),
        StringsGameScreen.lTrf: CustomDialogButton(
            context: context,
            actionTag: attackActionMapping[StringsGameScreen.lTrf]!,
            buttonText: StringsGameScreen.lTrf,
            buttonColor: Color.fromRGBO(203, 206, 227, 1),
            icon: Icon(Icons.remove_circle_outline)),
      };
    }
    if (actionState == actionStateDefense) {
      // tags action tags for the different buttons
      Map<String, String> defenseActionMapping =
          actionMapping[actionStateDefense]!;
      return {
        StringsGameScreen.lRedCard: CustomDialogButton(
            context: context,
            actionTag: defenseActionMapping[StringsGameScreen.lRedCard]!,
            buttonText: StringsGameScreen.lRedCard,
            buttonColor: Colors.red,
            sizeFactor: 0,
            icon: Icon(Icons.remove_circle_outline)),
        StringsGameScreen.lYellowCard: CustomDialogButton(
            context: context,
            actionTag: defenseActionMapping[StringsGameScreen.lYellowCard]!,
            buttonText: StringsGameScreen.lYellowCard,
            buttonColor: Colors.yellow,
            sizeFactor: 0,
            icon: Icon(Icons.remove_circle_outline)),
        StringsGameScreen.lFoul7m: CustomDialogButton(
            context: context,
            actionTag: defenseActionMapping[StringsGameScreen.lFoul7m]!,
            buttonText: StringsGameScreen.lFoul7m,
            buttonColor: Color.fromRGBO(203, 206, 227, 1),
            icon: Icon(Icons.remove_circle_outline)),
        StringsGameScreen.lTimePenalty: CustomDialogButton(
            context: context,
            actionTag: defenseActionMapping[StringsGameScreen.lTimePenalty]!,
            buttonText: StringsGameScreen.lTimePenalty,
            buttonColor: Color.fromRGBO(199, 208, 244, 1),
            sizeFactor: 1,
            icon: Icon(Icons.remove_circle_outline)),
        StringsGameScreen.lBlockNoBall: CustomDialogButton(
            context: context,
            actionTag: defenseActionMapping[StringsGameScreen.lBlockNoBall]!,
            buttonText: StringsGameScreen.lBlockNoBall,
            buttonColor: Color.fromRGBO(99, 107, 171, 1),
            icon: Icon(Icons.remove_circle_outline)),
        StringsGameScreen.lBlockAndSteal: CustomDialogButton(
            context: context,
            actionTag: defenseActionMapping[StringsGameScreen.lBlockAndSteal]!,
            buttonText: StringsGameScreen.lBlockAndSteal,
            buttonColor: Color.fromRGBO(99, 107, 171, 1),
            icon: Icon(Icons.remove_circle_outline)),
        StringsGameScreen.lTrf: CustomDialogButton(
            context: context,
            actionTag: defenseActionMapping[StringsGameScreen.lTrf]!,
            buttonText: StringsGameScreen.lTrf,
            buttonColor:  Color.fromRGBO(203, 206, 227, 1),
            icon: Icon(Icons.remove_circle_outline)),
        StringsGameScreen.lTwoMin: CustomDialogButton(
            context: context,
            actionTag: defenseActionMapping[StringsGameScreen.lTwoMin]!,
            buttonText: StringsGameScreen.lTwoMin,
            buttonColor: Color.fromRGBO(199, 208, 244, 1),
            sizeFactor: 1,
            icon: Icon(Icons.remove_circle_outline)),
      };
    }
    return {};
  }
}
