import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/utils/helper.dart';
import 'package:handball_performance_tracker/controllers/fieldSizeParameter.dart'
    as fieldSizeParameter;

class CustomField extends StatelessWidget {
  CustomField({Key? key}) : super(key: key);

  // Parameter to determine if right or left field side is shown
  bool leftSide = true;

  @override
  Widget build(BuildContext context) {
    //SizedBox around! und darum FittedBox!
    return SizedBox(
      width: fieldSizeParameter.fieldWidth,
      height: fieldSizeParameter.fieldHeight,
      child: CustomPaint(
        painter: FieldPainter(leftSide),
        // GestureDetector to get coordinates on click
        child: GestureDetector(
          onTapDown: (TapDownDetails details) =>
              SectorCalc(leftSide).calculatePosition(details.localPosition),
        ),
      ),
    );
  }
}
