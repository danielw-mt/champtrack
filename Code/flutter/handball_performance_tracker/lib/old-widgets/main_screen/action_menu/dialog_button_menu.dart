import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/data/models/player_model.dart';
import 'package:handball_performance_tracker/old-utils/feed_logic.dart';
import 'package:handball_performance_tracker/old-utils/player_helper.dart';
import 'package:handball_performance_tracker/old-widgets/helper_screen/alert_message_widget.dart';
import 'package:handball_performance_tracker/old-widgets/main_screen/action_menu/action_menu.dart';
import 'package:handball_performance_tracker/old-widgets/main_screen/ef_score_bar.dart';
import 'package:handball_performance_tracker/old-widgets/main_screen/field.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../../../old-constants/stringsGameScreen.dart';
import '../../../controllers/persistent_controller.dart';
import '../../../controllers/temp_controller.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../../data/models/game_action_model.dart';
import '../../../old-constants/game_actions.dart';
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
  final String actionContext;
  DialogButtonMenu({super.key, required this.actionContext});
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        thumbVisibility: true, controller: pageController, child: PageView(controller: pageController, children: buildPageViewChildren()));
  }

  // a method for building the children of the pageview in the right order
  // by arranging either the attack menu or defense menu first or the goal keeper menu
  List<Widget> buildPageViewChildren() {
    print("building page view children");
    if (actionContext == actionContextGoalkeeper) {
      return [ArrangedDialogButtons(actionContext: actionContext)];
    } else if (actionContext == actionContextAttack) {
      print("action state attack");
      return [
        ArrangedDialogButtons(actionContext: actionContextAttack),
        ArrangedDialogButtons(actionContext: actionContextDefense),
      ];
    } else if (actionContext == actionContextDefense) {
      return [
        ArrangedDialogButtons(actionContext: actionContextDefense),
        ArrangedDialogButtons(actionContext: actionContextAttack),
      ];
    } else {
      print("no page view children");
      return [Text("Could not build menu that is matching the phase of the game")];
    }
  }
}

class ArrangedDialogButtons extends StatelessWidget {
  final String actionContext;
  const ArrangedDialogButtons({super.key, required this.actionContext});

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
                if (actionContext == actionContextAttack) {
                  return StringsGameScreen.lOffensePopUpHeader;
                } else if (actionContext == actionContextGoalkeeper) {
                  return StringsGameScreen.lGoalkeeperPopUpHeader;
                } else if (actionContext == actionContextDefense) {
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
    Map<String, CustomDialogButton> dialogButtons = buildDialogButtons(context);
    if (actionContext == actionContextGoalkeeper) {
      buttonRow = Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                dialogButtons[StringsGameScreen.lYellowCard]!,
                dialogButtons[StringsGameScreen.lRedCard]!,
              ],
            ),
          ),
          Flexible(child: dialogButtons[StringsGameScreen.lTimePenalty]!),
          Flexible(child: dialogButtons[StringsGameScreen.lEmptyGoal]!),
          Flexible(child: dialogButtons[StringsGameScreen.lErrThrowGoalkeeper]!),
        ]),
        Flexible(
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Flexible(child: dialogButtons[StringsGameScreen.lGoalGoalkeeper]!),
            Flexible(child: dialogButtons[StringsGameScreen.lBadPass]!),
          ]),
        ),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(child: dialogButtons[StringsGameScreen.lParade]!),
              Flexible(child: dialogButtons[StringsGameScreen.lGoalOpponent]!),
            ],
          ),
        ),
      ]);
    } else if (actionContext == actionContextAttack) {
      logger.d("arranging dialog buttons for attack");
      buttonRow = Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [dialogButtons[StringsGameScreen.lYellowCard]!, dialogButtons[StringsGameScreen.lRedCard]!]),
          Flexible(child: dialogButtons[StringsGameScreen.lTwoMin]!),
          Flexible(child: dialogButtons[StringsGameScreen.lTimePenalty]!),
        ]),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [Flexible(child: dialogButtons[StringsGameScreen.lErrThrow]!), Flexible(child: dialogButtons[StringsGameScreen.lTrf]!)],
          ),
        ),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [Flexible(child: dialogButtons[StringsGameScreen.lGoal]!), Flexible(child: dialogButtons[StringsGameScreen.lOneVsOneAnd7m]!)],
          ),
        ),
      ]);
    } else {
      buttonRow = Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(children: [dialogButtons[StringsGameScreen.lYellowCard]!, dialogButtons[StringsGameScreen.lRedCard]!]),
            Flexible(child: dialogButtons[StringsGameScreen.lTwoMin]!),
            Flexible(child: dialogButtons[StringsGameScreen.lTimePenalty]!)
          ],
        ),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [Flexible(child: dialogButtons[StringsGameScreen.lFoul7m]!), Flexible(child: dialogButtons[StringsGameScreen.lTrf]!)],
          ),
        ),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

  // TODO clean up actionTag calls
  Map<String, CustomDialogButton> buildDialogButtons(BuildContext context) {
    print("building dialog buttons");
    if (actionContext == actionContextGoalkeeper) {
      Map<String, String> goalKeeperActionMapping = actionMapping[actionContextGoalkeeper]!;
      return {
        StringsGameScreen.lRedCard: CustomDialogButton(
            buildContext: context,
            actionTag: goalKeeperActionMapping[StringsGameScreen.lRedCard]!,
            actionContext: actionContextGoalkeeper,
            buttonText: StringsGameScreen.lRedCard,
            buttonColor: Colors.red,
            sizeFactor: 0,
            icon: Icon(Icons.style)),
        StringsGameScreen.lYellowCard: CustomDialogButton(
            buildContext: context,
            actionTag: goalKeeperActionMapping[StringsGameScreen.lYellowCard]!,
            actionContext: actionContextGoalkeeper,
            buttonText: StringsGameScreen.lYellowCard,
            buttonColor: Colors.yellow,
            sizeFactor: 0,
            icon: Icon(Icons.style)),
        StringsGameScreen.lTimePenalty: CustomDialogButton(
            buildContext: context,
            actionTag: goalKeeperActionMapping[StringsGameScreen.lTimePenalty]!,
            actionContext: actionContextGoalkeeper,
            buttonText: StringsGameScreen.lTimePenalty,
            buttonColor: Color.fromRGBO(199, 208, 244, 1),
            sizeFactor: 2,
            icon: Icon(Icons.timer)),
        StringsGameScreen.lEmptyGoal: CustomDialogButton(
          buildContext: context,
          actionTag: goalKeeperActionMapping[StringsGameScreen.lEmptyGoal]!,
          actionContext: actionContextGoalkeeper,
          buttonText: StringsGameScreen.lEmptyGoal,
          buttonColor: Color.fromRGBO(199, 208, 244, 1),
          sizeFactor: 2,
        ),
        StringsGameScreen.lErrThrowGoalkeeper: CustomDialogButton(
          buildContext: context,
          actionTag: goalKeeperActionMapping[StringsGameScreen.lErrThrowGoalkeeper]!,
          actionContext: actionContextGoalkeeper,
          buttonText: StringsGameScreen.lErrThrowGoalkeeper,
          buttonColor: Color.fromRGBO(199, 208, 244, 1),
          sizeFactor: 2,
        ),
        StringsGameScreen.lGoalGoalkeeper: CustomDialogButton(
          buildContext: context,
          actionTag: goalKeeperActionMapping[StringsGameScreen.lGoalGoalkeeper]!,
          actionContext: actionContextGoalkeeper,
          buttonText: StringsGameScreen.lGoalGoalkeeper,
          buttonColor: Color.fromRGBO(99, 107, 171, 1),
        ),
        StringsGameScreen.lBadPass: CustomDialogButton(
          buildContext: context,
          actionTag: goalKeeperActionMapping[StringsGameScreen.lBadPass]!,
          actionContext: actionContextGoalkeeper,
          buttonText: StringsGameScreen.lBadPass,
          buttonColor: Color.fromRGBO(203, 206, 227, 1),
        ),
        StringsGameScreen.lParade: CustomDialogButton(
          buildContext: context,
          actionTag: goalKeeperActionMapping[StringsGameScreen.lParade]!,
          actionContext: actionContextGoalkeeper,
          buttonText: StringsGameScreen.lParade,
          buttonColor: Color.fromRGBO(99, 107, 171, 1),
        ),
        StringsGameScreen.lGoalOpponent: CustomDialogButton(
          buildContext: context,
          actionTag: goalKeeperActionMapping[StringsGameScreen.lGoalOpponent]!,
          actionContext: actionContextGoalkeeper,
          buttonText: StringsGameScreen.lGoalOpponent,
          buttonColor: Color.fromRGBO(203, 206, 227, 1),
        ),
      };
    }
    if (actionContext == actionContextAttack) {
      Map<String, String> attackActionMapping = actionMapping[actionContextAttack]!;
      logger.d("attackActionMapping: $attackActionMapping");
      return {
        StringsGameScreen.lRedCard: CustomDialogButton(
            buildContext: context,
            actionTag: attackActionMapping[StringsGameScreen.lRedCard]!,
            actionContext: actionContextAttack,
            buttonText: StringsGameScreen.lRedCard,
            buttonColor: Colors.red,
            sizeFactor: 0,
            icon: Icon(Icons.style)),
        StringsGameScreen.lYellowCard: CustomDialogButton(
            buildContext: context,
            actionTag: attackActionMapping[StringsGameScreen.lYellowCard]!,
            actionContext: actionContextAttack,
            buttonText: StringsGameScreen.lYellowCard,
            buttonColor: Colors.yellow,
            sizeFactor: 0,
            icon: Icon(Icons.style)),
        StringsGameScreen.lTimePenalty: CustomDialogButton(
          buildContext: context,
          actionTag: attackActionMapping[StringsGameScreen.lTimePenalty]!,
          actionContext: actionContextAttack,
          buttonText: StringsGameScreen.lTimePenalty,
          buttonColor: Color.fromRGBO(199, 208, 244, 1),
          sizeFactor: 1,
        ),
        StringsGameScreen.lGoal: CustomDialogButton(
          buildContext: context,
          actionTag: attackActionMapping[StringsGameScreen.lGoal]!,
          actionContext: actionContextAttack,
          buttonText: StringsGameScreen.lGoal,
          buttonColor: Color.fromRGBO(99, 107, 171, 1),
        ),
        StringsGameScreen.lOneVsOneAnd7m: CustomDialogButton(
          buildContext: context,
          actionTag: attackActionMapping[StringsGameScreen.lOneVsOneAnd7m]!,
          actionContext: actionContextAttack,
          buttonText: StringsGameScreen.lOneVsOneAnd7m,
          buttonColor: Color.fromRGBO(99, 107, 171, 1),
        ),
        StringsGameScreen.lTwoMin: CustomDialogButton(
          buildContext: context,
          actionTag: attackActionMapping[StringsGameScreen.lTwoMin]!,
          actionContext: actionContextAttack,
          buttonText: StringsGameScreen.lTwoMin,
          buttonColor: Color.fromRGBO(199, 208, 244, 1),
          sizeFactor: 1,
        ),
        StringsGameScreen.lErrThrow: CustomDialogButton(
          buildContext: context,
          actionTag: attackActionMapping[StringsGameScreen.lErrThrow]!,
          actionContext: actionContextAttack,
          buttonText: StringsGameScreen.lErrThrow,
          buttonColor: Color.fromRGBO(203, 206, 227, 1),
        ),
        StringsGameScreen.lTrf: CustomDialogButton(
          buildContext: context,
          actionTag: attackActionMapping[StringsGameScreen.lTrf]!,
          actionContext: actionContextAttack,
          buttonText: StringsGameScreen.lTrf,
          buttonColor: Color.fromRGBO(203, 206, 227, 1),
        ),
      };
    }
    if (actionContext == actionContextDefense) {
      // tags action tags for the different buttons
      Map<String, String> defenseActionMapping = actionMapping[actionContextDefense]!;
      return {
        StringsGameScreen.lRedCard: CustomDialogButton(
            buildContext: context,
            actionTag: defenseActionMapping[StringsGameScreen.lRedCard]!,
            actionContext: actionContextDefense,
            buttonText: StringsGameScreen.lRedCard,
            buttonColor: Colors.red,
            sizeFactor: 0,
            icon: Icon(Icons.style)),
        StringsGameScreen.lYellowCard: CustomDialogButton(
            buildContext: context,
            actionTag: defenseActionMapping[StringsGameScreen.lYellowCard]!,
            actionContext: actionContextDefense,
            buttonText: StringsGameScreen.lYellowCard,
            buttonColor: Colors.yellow,
            sizeFactor: 0,
            icon: Icon(Icons.style)),
        StringsGameScreen.lFoul7m: CustomDialogButton(
          buildContext: context,
          actionTag: defenseActionMapping[StringsGameScreen.lFoul7m]!,
          actionContext: actionContextDefense,
          buttonText: StringsGameScreen.lFoul7m,
          buttonColor: Color.fromRGBO(203, 206, 227, 1),
        ),
        StringsGameScreen.lTimePenalty: CustomDialogButton(
            buildContext: context,
            actionTag: defenseActionMapping[StringsGameScreen.lTimePenalty]!,
            actionContext: actionContextDefense,
            buttonText: StringsGameScreen.lTimePenalty,
            buttonColor: Color.fromRGBO(199, 208, 244, 1),
            sizeFactor: 1,
            icon: Icon(Icons.timer)),
        StringsGameScreen.lBlockNoBall: CustomDialogButton(
          buildContext: context,
          actionTag: defenseActionMapping[StringsGameScreen.lBlockNoBall]!,
          actionContext: actionContextDefense,
          buttonText: StringsGameScreen.lBlockNoBall,
          buttonColor: Color.fromRGBO(99, 107, 171, 1),
        ),
        StringsGameScreen.lBlockAndSteal: CustomDialogButton(
          buildContext: context,
          actionTag: defenseActionMapping[StringsGameScreen.lBlockAndSteal]!,
          actionContext: actionContextDefense,
          buttonText: StringsGameScreen.lBlockAndSteal,
          buttonColor: Color.fromRGBO(99, 107, 171, 1),
        ),
        StringsGameScreen.lTrf: CustomDialogButton(
          buildContext: context,
          actionTag: defenseActionMapping[StringsGameScreen.lTrf]!,
          actionContext: actionContextDefense,
          buttonText: StringsGameScreen.lTrf,
          buttonColor: Color.fromRGBO(203, 206, 227, 1),
        ),
        StringsGameScreen.lTwoMin: CustomDialogButton(
          buildContext: context,
          actionTag: defenseActionMapping[StringsGameScreen.lTwoMin]!,
          actionContext: actionContextDefense,
          buttonText: StringsGameScreen.lTwoMin,
          buttonColor: Color.fromRGBO(199, 208, 244, 1),
          sizeFactor: 1,
        ),
      };
    }
    return {};
  }
}
