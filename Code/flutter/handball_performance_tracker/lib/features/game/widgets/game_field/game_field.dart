import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'field_painters.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Class that returns a FieldPainter with a GestureDetecture, i.e. the Painted halffield with the possibility to get coordinates on click.
class PaintedField extends StatelessWidget {
  bool fieldIsLeft;
  PaintedField({required this.fieldIsLeft});

  @override
  Widget build(BuildContext context) {
    final gameBloc = context.watch<GameBloc>();
    bool displayAttackColor = fieldIsLeft && gameBloc.state.attackIsLeft ||
        !fieldIsLeft && !gameBloc.state.attackIsLeft;
    return Stack(children: [
      // Painter of 7m, 6m and filled 9m
      CustomPaint(
        // Give colors: 9m(middle-dark),6m(dark),background(light)
        painter: FieldPainter(
            fieldIsLeft,
            displayAttackColor ? attackMiddleColor : defenseMiddleColor,
            displayAttackColor ? attackDarkColor : defenseDarkColor,
            displayAttackColor ? attackLightColor : defenseLightColor),
        // GestureDetector to handle on click or swipe
        child: GestureDetector(
          // handle coordinates on click
          onTapDown: (TapDownDetails details) {
            gameBloc.add(RegisterClickOnField(
                fieldIsLeft: fieldIsLeft, position: details.localPosition));
            openWorkflowPopup(context, gameBloc);
          },
          onHorizontalDragUpdate: (details) {
            // Swiping in left direction.
            if (details.delta.dx < 0) {
              if (gameBloc.state.attackIsLeft)
                gameBloc.add(SwipeField(isLeft: false));
              else
                gameBloc.add(SwipeField(isLeft: true));
            }
            // Swiping in right direction.
            if (details.delta.dx > 0) {
              if (gameBloc.state.attackIsLeft)
                gameBloc.add(SwipeField(isLeft: true));
              else
                gameBloc.add(SwipeField(isLeft: false));
            }
          },
        ),
      ),
      // Painter of dashed 9m
      CustomPaint(
          painter: DashedPathPainter(leftSide: fieldIsLeft, isEllipse: true)),
      // Painter of dashed goal
      CustomPaint(
          painter: DashedPathPainter(leftSide: fieldIsLeft, isEllipse: false)),
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
    return BlocBuilder<GameBloc, GameState>(
        bloc: context.watch<GameBloc>(),
        builder: (context, state) {
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 350),
              child: state.attacking
                  ? PageView(key: ValueKey<int>(0), children: <Widget>[
                      PaintedField(
                        fieldIsLeft: true,
                      ),
                      PaintedField(
                        fieldIsLeft: false,
                      ),
                    ])
                  : PageView(
                      key: ValueKey<int>(1),
                      reverse: true,
                      children: <Widget>[
                          PaintedField(
                            fieldIsLeft: false,
                          ),
                          PaintedField(
                            fieldIsLeft: true,
                          ),
                        ]));
        });
  }
}
