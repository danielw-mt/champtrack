import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/game_actions.dart';
import 'package:handball_performance_tracker/utils/icons.dart';
import 'package:handball_performance_tracker/data/database_repository.dart';
import 'package:handball_performance_tracker/data/game.dart';
import 'package:handball_performance_tracker/widgets/main_screen/seven_meter_menu.dart';
import '../../strings.dart';
import '../../controllers/tempController.dart';
import 'package:handball_performance_tracker/utils/player_helper.dart';
import 'package:handball_performance_tracker/widgets/main_screen/field.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';
import '../../utils/feed_logic.dart';
import '../../data/game_action.dart';
import '../../data/player.dart';
import 'package:logger/logger.dart';

// TODO fix case of offensive actions from defensive side

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
