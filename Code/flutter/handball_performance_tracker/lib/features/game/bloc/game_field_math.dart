import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/constants/game_actions.dart';
import 'package:handball_performance_tracker/core/constants/field_size_parameters.dart' as fieldSizeParameter;
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:handball_performance_tracker/core/constants/positions.dart';

/* Class to calculate if a click was inside or outside a section.
* 
* @param  bool leftSide : true if we look at left field side
*         num xOffset : zero if we look at left field side, field width (max x value) if we look at right field side
*/
class SectorCalc {
  bool leftSide = true;
  late num xOffset;

  SectorCalc(this.leftSide) {
    if (leftSide) {
      xOffset = 0;
    } else {
      xOffset = fieldSizeParameter.fieldWidth;
    }
  }

  /* 
   * @return List<String> consisting of two elements
   * the first element is the sector's String abbreviation (as taken from positions.dart, either leftOutside, backcourtLeft, backcourtMiddle, backcourtRight, or rightOutside),
   * the second element is the distance of the player from the goal (<6, 6to9, >9)
   */
  List<String> calculatePosition(Offset position) {
    num x = position.dx;
    num y = position.dy;
    if (determineGoal(x, y)) {
      return [goalTag];
    }
    String sector = determineSector(x, y);
    String perimeters = determinePerimeter(x, y);
    return [sector, perimeters];
  }

  /* Calculates if a point (x,y) is inside the smaller ellipse.
  * 
  * @return  true if (x,y) is inside and otherwise false.
  */
  inSixMeterEllipse(num x, num y) {
    num yCentered = y - fieldSizeParameter.fieldHeight / 2;
    num xCentered = x - xOffset;
    return (xCentered * xCentered) / (fieldSizeParameter.sixMeterRadiusX * fieldSizeParameter.sixMeterRadiusX) +
            (yCentered * yCentered) / (fieldSizeParameter.sixMeterRadiusY * fieldSizeParameter.sixMeterRadiusY) <=
        1;
  }

  /* Calculates if a point (x,y) is inside the bigger ellipse.
  * 
  * @return  true if (x,y) is inside and otherwise false.
  */
  inNineMeterEllipse(num x, num y) {
    num yCentered = y - fieldSizeParameter.fieldHeight / 2;
    num xCentered = x - xOffset;
    return (xCentered * xCentered) / (fieldSizeParameter.nineMeterRadiusX * fieldSizeParameter.nineMeterRadiusX) +
            (yCentered * yCentered) / (fieldSizeParameter.nineMeterRadiusY * fieldSizeParameter.nineMeterRadiusY) <=
        1;
  }

  /* Calculates if a point (x,y) is inside the goal.
  * 
  * @return  true if (x,y) is inside and otherwise false.
  */
  bool determineGoal(num x, num y) {
    bool inGoal = y > fieldSizeParameter.fieldHeight / 2 - fieldSizeParameter.goalHeight / 2 &&
        y < fieldSizeParameter.fieldHeight / 2 + fieldSizeParameter.goalHeight / 2;
    if (leftSide) {
      inGoal = inGoal && x < fieldSizeParameter.goalWidth;
    } else {
      inGoal = inGoal && x > fieldSizeParameter.fieldWidth - fieldSizeParameter.goalWidth;
    }
    return inGoal;
  }

  /// deterime whether throw was from within 6m, 9m or further
  /// @return String (<6, 6to9, >9)
  String determinePerimeter(num x, num y) {
    bool inNineMeter = inNineMeterEllipse(x, y);
    bool inSixMeter = inSixMeterEllipse(x, y);
    if (inNineMeter) {
      if (inSixMeter) {
        return inSixThrowPos;
      } else {
        return interSixAndNineThrowPos;
      }
    } else {
      return extNineThrowPos;
    }
  }

  /* 
  * Calculates in which sector of the field (leftOutside, backcourtLeft, backcourtMiddle, backcourtRight, or rightOutside) a point (x,y) is situated 
  */
  String determineSector(num x, num y) {
    int sector = -1;

    // variables for gradient and intercept of lower line, the first lower line is the bottom horizontal line
    num lowerGradient = 0;
    num lowerIntercept = fieldSizeParameter.fieldHeight;
    // copy list of gradients and intercepts and add zeros, to have the upper section border (upper horizontal line)
    List gradients = List.from(fieldSizeParameter.gradients);
    List yIntercepts = List.from(fieldSizeParameter.yIntercepts);
    gradients.add(0.0);
    yIntercepts.add(0.0);
    // go through each line and check if (x,y) is below this line and still above the line below
    for (int i = 0; i < gradients.length; i++) {
      num gradient;
      num yIntercept;
      if (leftSide) {
        // left side
        gradient = gradients[i];
        yIntercept = yIntercepts[i];
      } else {
        // right side
        gradient = -gradients[i];
        yIntercept = yIntercepts[i] - gradient * xOffset;
      }
      // check if (x,y) is below this line and still above the line below
      bool inSector = (gradient * x + yIntercept <= y) && (lowerGradient * x + lowerIntercept > y);
      lowerGradient = gradient;
      lowerIntercept = yIntercept;
      if (inSector == true) {
        sector = i;
      }
    }
    String sectorOnField = "";
    if (leftSide) {
      sectorOnField = sectorsFieldIsLeft[sector];
    } else {
      sectorOnField = sectorsFieldIsRight[sector];
    }
    print(sectorOnField);
    return sectorOnField;
  }
}