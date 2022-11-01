import '../controllers/temp_controller.dart';
import 'package:handball_performance_tracker/old-widgets/main_screen/field.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

// TODO fix case of offensive actions from defensive side

var logger = Logger(
  printer: PrettyPrinter(
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: false // Should each log print contain a timestamp
      ),
);

/// Switch the field from defense to offense
void defensiveFieldSwitch() {
  final TempController tempController = Get.find<TempController>();
  // if our action is left (page 0) and we are defensing (on page 0) jump back to attack (page 1) after the action
  if (tempController.getFieldIsLeft() == true &&
      tempController.getAttackIsLeft() == false) {
    logger.d("Switching to right field after action");
    while (FieldSwitch.pageController.positions.length > 1) {
      FieldSwitch.pageController
          .detach(FieldSwitch.pageController.positions.first);
    }
    FieldSwitch.pageController.jumpToPage(1);

    // if out action is right (page 1) and we are defensing (on page 1) jump back to attack (page 0) after the action
  } else if (tempController.getFieldIsLeft() == false &&
      tempController.getAttackIsLeft() == true) {
    logger.d("Switching to left field after action");
    while (FieldSwitch.pageController.positions.length > 1) {
      FieldSwitch.pageController
          .detach(FieldSwitch.pageController.positions.first);
    }
    FieldSwitch.pageController.jumpToPage(0);
  }
}

/// Switch the field from offense to defense
void offensiveFieldSwitch() {
  final TempController tempController = Get.find<TempController>();
  // if our action is left (page 0) and we are attacking (on page 0) jump back to defense (page 1) after the action
  if (tempController.getFieldIsLeft() == true &&
      tempController.getAttackIsLeft() == true) {
    logger.d("Switching to right field after action");
    while (FieldSwitch.pageController.positions.length > 1) {
      FieldSwitch.pageController
          .detach(FieldSwitch.pageController.positions.first);
    }
    FieldSwitch.pageController.jumpToPage(1);

    // if out action is right (page 1) and we are attacking (on page 1) jump back to defense (page 0) after the action
  } else if (tempController.getFieldIsLeft() == false &&
      tempController.getAttackIsLeft() == false) {
    logger.d("Switching to left field after action");
    while (FieldSwitch.pageController.positions.length > 1) {
      FieldSwitch.pageController
          .detach(FieldSwitch.pageController.positions.first);
    }
    FieldSwitch.pageController.jumpToPage(0);
  }
}
