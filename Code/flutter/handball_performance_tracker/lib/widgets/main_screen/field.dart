import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/colors.dart';
import 'package:handball_performance_tracker/utils/main_screen_field_helper.dart';
import '../../controllers/temp_controller.dart';
import 'package:get/get.dart';
import 'action_menu/action_menu.dart';

// Class that returns a FieldPainter with a GestureDetecture, i.e. the Painted halffield with the possibility to get coordinates on click.
class CustomField extends StatelessWidget {
  final TempController tempController = Get.find<TempController>();
  bool fieldIsLeft = true;
  CustomField({required fieldIsLeft}) {
    this.fieldIsLeft = fieldIsLeft;
  }
  @override
  Widget build(BuildContext context) {
    tempController.setFieldIsLeft(this.fieldIsLeft);
    return GetBuilder<TempController>(
      id: "custom-field",
      builder: (TempController tempController) => Stack(children: [
        // Painter of 7m, 6m and filled 9m
        CustomPaint(
          // Give colors: 9m(middle-dark),6m(dark),background(light)
          painter: FieldPainter(
            fieldIsLeft,
            (fieldIsLeft && tempController.getAttackIsLeft() ||
                    !fieldIsLeft && !tempController.getAttackIsLeft())
                ? attackMiddleColor
                : defenseMiddleColor,
            (fieldIsLeft && tempController.getAttackIsLeft() ||
                    !fieldIsLeft && !tempController.getAttackIsLeft())
                ? attackDarkColor
                : defenseDarkColor,
            (fieldIsLeft && tempController.getAttackIsLeft() ||
                    !fieldIsLeft && !tempController.getAttackIsLeft())
                ? attackLightColor
                : defenseLightColor,
          ),
          // GestureDetector to handle on click or swipe
          child: GestureDetector(
              // handle coordinates on click
              onTapDown: (TapDownDetails details) {
            // Set last location in controller before calling action menu, because it is queried there.
            tempController.setLastLocation(SectorCalc(fieldIsLeft)
                .calculatePosition(details.localPosition));
            callActionMenu(context);
          }),
        ),
        // Painter of dashed 9m
        CustomPaint(
            painter: DashedPathPainter(leftSide: fieldIsLeft, isEllipse: true)),
        // Painter of dashed goal
        CustomPaint(
            painter:
                DashedPathPainter(leftSide: fieldIsLeft, isEllipse: false)),
      ]),
    );
  }
}

class CustomCardField extends StatelessWidget {
  //final TempController tempController = Get.find<TempController>();
  final List<dynamic> actionCoordinates;
  final bool fieldIsLeft;
  final List<String> actionContext;
  CustomCardField(this.actionCoordinates, this.fieldIsLeft, this.actionContext);
  
  //final Map<String, List<dynamic>> actionCoordinates = thi;

  // TODO logic for foregroundpainter doing the heatmap depending on where actions are

  @override
  Widget build(BuildContext context) {
    List<dynamic> viewed_coordinates = actionCoordinates;//[viewed_action]!;
    //int nb_actions = viewed_coordinates.length;

    //List<double> opacitySector = [0.5];

    return GetBuilder<TempController>(
      id: "custom-card-field",
      builder: (TempController tempController) => Stack(children: [
        // Painter of 7m, 6m and filled 9m
        CustomPaint(
          // Give colors: 9m(middle-dark),6m(dark),background(light)
          painter: CardFieldPainter(fieldIsLeft, (fieldIsLeft && tempController.getAttackIsLeft() ||
                    !fieldIsLeft && !tempController.getAttackIsLeft())
                ? attackMiddleColor
                : defenseMiddleColor,
            (fieldIsLeft && tempController.getAttackIsLeft() ||
                    !fieldIsLeft && !tempController.getAttackIsLeft())
                ? attackDarkColor
                : defenseDarkColor,
            (fieldIsLeft && tempController.getAttackIsLeft() ||
                    !fieldIsLeft && !tempController.getAttackIsLeft())
                ? attackLightColor
                : defenseLightColor),
          child: Container(),
          foregroundPainter: HeatmapOverlayPainter(
              color: Colors.red,
              fieldIsLeft: true,
              isEllipse: false,
              coordinates: viewed_coordinates,
              actionContext: actionContext),
        ),

        // TODO integrate paint lines into CardFieldPainter
        // Painter of dashed 9m
        // CustomPaint(
        //     painter: DashedPathPainter(leftSide: fieldIsLeft, isEllipse: true)),
        // // Painter of dashed goal
        // CustomPaint(
        //     painter:
        //         DashedPathPainter(leftSide: fieldIsLeft, isEllipse: false)),
      ]),
    );
  }
}

/*
* FieldSwitch uses Pageview to make it possible to swipe between left and right field side.
* @return   Returns a Pageview with left field side and right field side as children.
*/
class FieldSwitch extends StatelessWidget {
  static final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
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

class CardFieldSwitch extends StatelessWidget {
  final List<dynamic> actionCoordinates;
  final List<String> actionContext;
  CardFieldSwitch(this.actionCoordinates, List<String> this.actionContext);

  static final PageController pageController = PageController();



  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: <Widget>[
        CustomCardField(actionCoordinates.where((i) => i["context"] == "attack").toList(), true, actionContext),
        CustomCardField(actionCoordinates.where((i) => i["context"] != "attack").toList(), false, actionContext),
      ],
    );
  }
}
