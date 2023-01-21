import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'dart:math';

/// @return
/// builds a single dialog button that logs its actiontag to firestore
//  and updates the game state. Its color and icon can be specified as parameters
// @params - sizeFactor: 0 for small buttons, 1 for middle big buttons, 2 for long buttons, anything else for big buttons
//         - otherText: Text to display if it should not equal the text in actionMapping

class ActionButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  int? sizeFactor;
  Icon? icon;
  String? otherText;
  final String actionTag;
  final String actionContext;
  ActionButton(
      {super.key,
      required this.actionTag,
      required this.actionContext,
      this.buttonText = "",
      this.buttonColor = Colors.blue,
      this.sizeFactor,
      this.icon,
      this.otherText});

  @override
  Widget build(BuildContext context) {
    final GameBloc gameBloc = context.watch<GameBloc>();
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    double buttonWidth;
    double buttonHeight;
    if (sizeFactor == 0) {
      // Small buttons, eg red and yellow card
      buttonWidth = width * 0.07;
      buttonHeight = buttonWidth;
    } else if (sizeFactor == 1) {
      // Middle big buttons, eg 2m
      buttonWidth = width * 0.13;
      buttonHeight = buttonWidth;
    } else if (sizeFactor == 2) {
      // Long buttons like in goalkeeper menu
      buttonWidth = width * 0.25;
      buttonHeight = width * 0.17;
      // if no size factor provided
    } else {
      // Big buttons like goal
      buttonWidth = width * 0.17;
      buttonHeight = buttonWidth;
    }
    return GestureDetector(
        child: Container(
          margin: sizeFactor == 0 // less margin for smallest buttons
              ? EdgeInsets.all(min(height, width) * 0.013)
              : EdgeInsets.all(min(height, width) * 0.02),
          decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(15)), color: buttonColor),
          // have round edges with same degree as Alert dialog
          // set height and width of buttons so the shirt and name are fitting inside
          height: buttonHeight,
          width: buttonWidth,
          child: Center(
            child: Column(
              children: [
                // if icon is null use a container
                icon ?? Container(),
                Text(
                  // if otherText is null use buttonText
                  otherText ?? buttonText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
        ),
        onTap: () {
          gameBloc.add(RegisterAction(actionTag: actionTag, actionContext: actionContext));
        });
  }
}
