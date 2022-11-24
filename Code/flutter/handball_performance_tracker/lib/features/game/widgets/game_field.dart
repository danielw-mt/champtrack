import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/constants/colors.dart';
import 'package:handball_performance_tracker/old-utils/main_screen_field_helper.dart';
import 'action_menu/action_menu.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Class that returns a FieldPainter with a GestureDetecture, i.e. the Painted halffield with the possibility to get coordinates on click.
class PaintedField extends StatelessWidget {
  bool fieldIsLeft;
  PaintedField({required this.fieldIsLeft});

  @override
  Widget build(BuildContext context) {
    final gameBloc = context.watch<GameBloc>();
    print("PaintedField build");
    bool displayAttackColor = fieldIsLeft && gameBloc.state.attackIsLeft || !fieldIsLeft && !gameBloc.state.attackIsLeft;
    print("displayAttackColor: $displayAttackColor");
    return Stack(children: [
      // Painter of 7m, 6m and filled 9m
      CustomPaint(
        // Give colors: 9m(middle-dark),6m(dark),background(light)
        painter: FieldPainter(fieldIsLeft, displayAttackColor ? attackMiddleColor : defenseMiddleColor,
            displayAttackColor ? attackDarkColor : defenseDarkColor, displayAttackColor ? attackLightColor : defenseLightColor),
        // GestureDetector to handle on click or swipe
        child: GestureDetector(
            // handle coordinates on click
            onTapDown: (TapDownDetails details) {
          // Set last location in controller before calling action menu, because it is queried there.
          // Old code:
          //tempController.setLastLocation(SectorCalc(fieldIsLeft).calculatePosition(details.localPosition));
          //gameBloc.add(RegisterClickOnField(position: details.localPosition));
          // TODO call action menu from bloc
          //callActionMenu(context);
        }),
      ),
      // Painter of dashed 9m
      CustomPaint(painter: DashedPathPainter(leftSide: fieldIsLeft, isEllipse: true)),
      // Painter of dashed goal
      CustomPaint(painter: DashedPathPainter(leftSide: fieldIsLeft, isEllipse: false)),
    ]);
  }
}

/*
* FieldSwitch uses Pageview to make it possible to swipe between left and right field side.
* @return   Returns a Pageview with left field side and right field side as children.
*/
class GameField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameBloc = context.watch<GameBloc>();
    return PageView(
      onPageChanged: (value) {
        gameBloc.add(SwipeField(isLeft: value == 0));
      },
      children: <Widget>[
        PaintedField(
          fieldIsLeft: true,
        ),
        PaintedField(
          fieldIsLeft: false,
        ),
      ],
    );
  }
}
