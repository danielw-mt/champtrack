import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:handball_performance_tracker/core/constants/field_size_parameters.dart' as fieldSizeParameter;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
// TODO do we need this package?
import 'package:rainbow_color/rainbow_color.dart';
import 'ef_score_bar_button.dart';
import 'package:handball_performance_tracker/data/models/models.dart';

// TODO get rid of all these constants here this is a really bad practice

// Radius of round edges
double menuRadius = 8.0;
double buttonRadius = 8.0;
// Width of padding between buttons
double paddingWidth = 8.0;
// height of button + line between buttons.
double lineAndButtonHeight = fieldSizeParameter.fieldHeight / 7;
// height of a button -> The full height should be used when 7 buttons are displayed.
double buttonHeight = (fieldSizeParameter.fieldHeight - paddingWidth * 5.5) / 7;
// width of popup
double popupWidth = buttonHeight + 3 * paddingWidth;
// width of efscore bar
double scorebarWidth = popupWidth * 2.3 - 2 * paddingWidth;
// width of a button in scorebar
double scorebarButtonWidth = scorebarWidth;
// track if plus button was pressed, so the adapted color of the pressed player on efscore bar does not change back to normal already.
bool plusPressed = false;
// Color of unpressed button
Color buttonColor = Colors.white;
// Color of pressed button
Color pressedButtonColor = Colors.blue;
double numberFontSize = 18;
double nameFontSize = 14;
// Spectrum for color coding of efscore
var rb = Rainbow(spectrum: [
  Color(0xffe99e9f),
  Color(0xfff0d4b2),
  Color(0xfff5fabf),
  Color(0xffdef6c1),
  Color(0xffbff2c4),
], rangeStart: -7.0, rangeEnd: 7.0);

/*
* Class that builds the column with buttons for both permanent efscore player bar and player changing popup.
* @param buttons: List of Container which will be pub into a ListView
* @param width: Width of column, is bigger for permanent efscore player bar.
* @return: Container with ListView which shows the entries of the input list.
*/
class EfScoreBar extends StatelessWidget {
  // TODO implement width and padwith within this class.  Playerbar layout should be self contained
  // double width;
  // double padWidth;
  List<EfScoreBarButton> buttons = [];
  EfScoreBar({required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(PADDING_WIDTH),
      // width: width.toDouble(),
      // height: (buttons.length * lineAndButtonHeight + paddingWidth).toDouble(),
      decoration: BoxDecoration(
          color: backgroundColor,
          // set border so corners can be made round
          border: Border.all(
            color: backgroundColor,
          ),
          // make round edges
          borderRadius: BorderRadius.all(Radius.circular(menuRadius))),
      // ListView which has all given Container-Buttons as entries
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return buttons[index];
        },
        // line between the buttons
        separatorBuilder: (BuildContext context, int index) => Divider(
          color: Colors.white,
          height: paddingWidth,
        ),
        itemCount: buttons.length,
      ),
    );
  }
}
