import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/utils/main_screen_field_helper.dart';

// Class that returns a FieldPainter with a GestureDetecture, i.e. the Painted halffield with the possibility to get coordinates on click.
class CustomField extends StatelessWidget {
  const CustomField({Key? key, required this.leftSide}) : super(key: key);

  // Parameter to determine if right or left field side is shown
  final bool leftSide;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: FieldPainter(leftSide),
      // GestureDetector to handle on click or swipe
      child: GestureDetector(
        // handle coordinates on click
        onTapDown: (TapDownDetails details) =>
            SectorCalc(leftSide).calculatePosition(details.localPosition),
      ),
    );
  }
}

/*
* FieldSwitch uses Pageview to make it possible to swipe between left and right field side.
* @return   Returns a Pageview with left field side and right field side as children.
*/
class FieldSwitch extends StatelessWidget {
  const FieldSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: <Widget>[
        const CustomField(
          leftSide: true,
        ),
        const CustomField(
          leftSide: false,
        ),
      ],
    );
  }
}
