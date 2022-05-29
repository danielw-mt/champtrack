import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/utils/main_screen_field_helper.dart';
import '../../controllers/globalController.dart';
import 'package:get/get.dart';
import 'actionmenu.dart';

// Class that returns a FieldPainter with a GestureDetecture, i.e. the Painted halffield with the possibility to get coordinates on click.
class CustomField extends StatelessWidget {
  final GlobalController globalController = Get.find<GlobalController>();
  bool fieldIsLeft = true;
  CustomField({required fieldIsLeft}) {
    this.fieldIsLeft = fieldIsLeft;
  }
  @override
  Widget build(BuildContext context) {
    globalController.fieldIsLeft.value = this.fieldIsLeft;
    return Stack(children: [
      // Painter of 7m, 6m and filled 9m
      CustomPaint(
        painter: FieldPainter(fieldIsLeft),
        // GestureDetector to handle on click or swipe
        child: GestureDetector(
            // handle coordinates on click
            onTapDown: (TapDownDetails details) {
          callActionMenu(context);
          String location =
              SectorCalc(fieldIsLeft).calculatePosition(details.localPosition);
          globalController.lastLocation.value = location;
        }),
      ),
      // Painter of dashed 9m
      CustomPaint(painter: DashedPathPainter(leftSide: fieldIsLeft))
    ]);
  }
}

/*
* FieldSwitch uses Pageview to make it possible to swipe between left and right field side.
* @return   Returns a Pageview with left field side and right field side as children.
*/
class FieldSwitch extends StatelessWidget {
  final GlobalController globalController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: <Widget>[
        CustomField(
          fieldIsLeft: true,
        ),
        CustomField(
          fieldIsLeft: false,
        ),
      ],
    );
  }
}
