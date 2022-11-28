import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/constants/colors.dart';
import 'package:handball_performance_tracker/core/constants/positions.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/features/game/bloc/game_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/core/constants/field_size_parameters.dart' as fieldSizeParameter;
import 'package:handball_performance_tracker/features/game/widgets/ef_score_bar/ef_score_bar_button.dart';
import 'package:handball_performance_tracker/old-utils/player_helper.dart';
import 'dart:math';
import 'ef_score_bar.dart';
// TODO do we need this package?
import 'package:rainbow_color/rainbow_color.dart';

// TODO get rid of all these design constants here. This is a really bad practice

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

// Opens a popup menu besides the Efscorebar.
// @param buttons: Buttons to be displayed in popup
// @param i: index of button to adapt the vertical position so the popup opens besides the pressed button.
void showPopup(BuildContext context, List<EfScoreBarButton> buttons, int i) {
  final gameBloc = context.watch<GameBloc>();
  int topPadding = i < 3 ? max((i - (buttons.length / 2).truncate()), 0) : max((i - (buttons.length / 2).round()), 0);
  topPadding = buttons.length == 1 ? i : topPadding;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(

            // Make round borders.
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(menuRadius),
            ),

            // Set padding to all sides, so the popup has the needed size and position.
            insetPadding: EdgeInsets.only(
                // The dialog should appear on the right side of Efscore bar, so the padding on the left side need to be around width of scorebar.
                left: fieldSizeParameter.screenWidth - (fieldSizeParameter.fieldWidth + paddingWidth * 4 - scorebarWidth) - scorebarWidth,
                // As the dialog has also width = popupWidth, the right side padding is whole screenWidth-2*popupWidth
                right: fieldSizeParameter.fieldWidth + paddingWidth * 2 - scorebarWidth,
                // The dialog should open below the toolbar and other padding. Depending on the position (=index i) of the pressed button,
                // the top padding changes, so the dialog opens more or less besides the pressed button.
                top: fieldSizeParameter.toolbarHeight + fieldSizeParameter.paddingTop + topPadding * lineAndButtonHeight - paddingWidth * 6,
                // Bottom padding is determined similar to top padding.
                bottom: fieldSizeParameter.paddingBottom + max(((7 - i) - buttons.length), 0) * lineAndButtonHeight),
            // Set contentPadding to zero so there is no white padding around the bar.
            contentPadding: EdgeInsets.zero,
            content: Builder(
              builder: (context) {
                plusPressed = false;
                // show a ButtonBar inside the dialog with given buttons.
                return EfScoreBar(
                  buttons: buttons,
                  width: scorebarWidth,
                  padWidth: paddingWidth,
                );
              },
            ));
      });
  // TODO not sure when this comes into play but validate
  // When closing check if Popup closes because the plus button was pressed (=> player is still selected on efscore bar)
  // or because of other reasons (chose a player for substitution or just pressed anywhere in screen => player is unselected)
  // .then((_) => plusPressed ? null : gameBloc.add(RegisterClickOnPlayer(player: Player())));
}
