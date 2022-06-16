import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/utils/main_screen_field_helper.dart';
import '../../controllers/globalController.dart';
import 'package:get/get.dart';
import 'action_menu.dart';

// Class that returns a FieldPainter with a GestureDetecture, i.e. the Painted halffield with the possibility to get coordinates on click.
class CustomField extends StatelessWidget {
  // final GlobalController globalController = Get.find<GlobalController>();
  bool fieldIsLeft = true;
  CustomField({required fieldIsLeft}) {
    this.fieldIsLeft = fieldIsLeft;
  }
  @override
  Widget build(BuildContext context) {
    // globalController.fieldIsLeft.value = this.fieldIsLeft;
    return GetBuilder<GlobalController>(
      builder: (GlobalController globalController) => Stack(children: [
        // Painter of 7m, 6m and filled 9m
        CustomPaint(
          painter: FieldPainter(fieldIsLeft),
          // GestureDetector to handle on click or swipe
          child: GestureDetector(
              // handle coordinates on click
              onTapDown: (TapDownDetails details) {
            callActionMenu(context);
            List<String> location = SectorCalc(fieldIsLeft)
                .calculatePosition(details.localPosition);
            globalController.lastLocation.value = location;
          }),
        ),
        // Painter of dashed 9m
        CustomPaint(painter: DashedPathPainter(leftSide: fieldIsLeft))
      ]),
    );
  }
}

/*
* FieldSwitch uses Pageview to make it possible to swipe between left and right field side.
* @return   Returns a Pageview with left field side and right field side as children.
*/
class FieldSwitch extends StatelessWidget {
  // PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalController>(
      builder: (GlobalController globalController) {
        if (globalController.fieldIsLeft.value == true){
          return GestureDetector(onPanUpdate: (details){
            // swipe right
            if (details.delta.dx > 0){
              logger.d("Swipe to the right detected");
              globalController.fieldIsLeft.value = false;
              globalController.refresh();
            }
          },child: CustomField(fieldIsLeft: true),);
        } 
        else {
          return GestureDetector(onPanUpdate: (details){
            // swipe left
            if (details.delta.dx < 0){
              logger.d("Swipe to the left detected");
              globalController.fieldIsLeft.value = true;
              globalController.refresh();
            }
          },child: CustomField(fieldIsLeft: false),);
        }


        // globalController.fieldController.value = pageController;
        // if (globalController.fieldController.value.hasClients &&
        //     globalController.fieldController.value.positions.length > 1 &&
        //     globalController.fieldIsLeft.value == true) {
        //   pageController.jumpToPage(0);
        // } else {
        //   pageController.jumpToPage(1);
        // }
        // return PageView.builder(
        //   itemCount: 2,
        //   controller: globalController.fieldController.value,
        //   onPageChanged: (int page) {
        //     print("Switching back from: ${globalController.fieldIsLeft.value}");
        //     globalController.fieldIsLeft.value =
        //         !globalController.fieldIsLeft.value;
        //     // if (globalController.fieldIsLeft.value == true) {
        //     //   globalController.fieldController.value.jumpToPage(0);
        //     // } else {
        //     //   globalController.fieldController.value.jumpToPage(1);
        //     // }
        //     // globalController.refresh();
        //   },
        //   itemBuilder: (BuildContext context, int item){
        //     if (item == 0){
        //       return CustomField(
        //       fieldIsLeft: true,
        //     );
        //     } else {
        //       return CustomField(
        //       fieldIsLeft: false,
        //     );
        //     }
        //   },
        // );
      },
    );
  }
}
