import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/utils/fieldSizeParameter.dart'
    as fieldSizeParameter;

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

  String calculatePosition(Offset position) {
    num x = position.dx;
    num y = position.dy;

    int sector = determineSector(x, y);
    String perimeters = determinePerimeter(x, y);
    return "sector "+sector.toString()+" and "+perimeters;
  }

  /* Calculates if a point (x,y) is inside the smaller ellipse.
  * 
  * @return  true if (x,y) is inside and otherwise false.
  */
  inSixMeterEllipse(num x, num y) {
    num yCentered = y - fieldSizeParameter.fieldHeight / 2;
    num xCentered = x - xOffset;
    return (xCentered * xCentered) /
                (fieldSizeParameter.sixMeterRadiusX *
                    fieldSizeParameter.sixMeterRadiusX) +
            (yCentered * yCentered) /
                (fieldSizeParameter.sixMeterRadiusY *
                    fieldSizeParameter.sixMeterRadiusY) <=
        1;
  }

  /* Calculates if a point (x,y) is inside the bigger ellipse.
  * 
  * @return  true if (x,y) is inside and otherwise false.
  */
  inNineMeterEllipse(num x, num y) {
    num yCentered = y - fieldSizeParameter.fieldHeight / 2;
    num xCentered = x - xOffset;
    return (xCentered * xCentered) /
                (fieldSizeParameter.nineMeterRadiusX *
                    fieldSizeParameter.nineMeterRadiusX) +
            (yCentered * yCentered) /
                (fieldSizeParameter.nineMeterRadiusY *
                    fieldSizeParameter.nineMeterRadiusY) <=
        1;
  }

  /// deterime whether throw was from within 6m, 9m or further
  /// @return boolan list [within 6m, within 9m]
  String determinePerimeter(num x, num y) {
    String in9m = "";
    String in6m = "";
    if (inNineMeterEllipse(x, y)) {
      in9m = "in 9m";
    } else {
      in9m = "not in 9m";
    }

    if (inSixMeterEllipse(x, y)) {
      in6m = "in 6m";
    } else {
      in6m = "not in 6m";
    }
    return in6m + " and "+in9m;
  }

  /* 
  * Calculates if a point (x,y) is between two sector borders. 
  */
  int determineSector(num x, num y) {
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
      bool inSector = (gradient * x + yIntercept <= y) &&
          (lowerGradient * x + lowerIntercept > y);
      //print("is in Sector $i : $inSector");
      lowerGradient = gradient;
      lowerIntercept = yIntercept;
      if (inSector == true) {
        sector = i;
      }
    }
    return sector;
  }
}

/* Class that paints the fiels, this means two ovals and sector borders as determined in fieldSizeParameter.dart.
* 
* @param  bool leftSide : true if we look at left field side
*/
class FieldPainter extends CustomPainter {
  bool leftSide = true;
  FieldPainter(this.leftSide);

  @override
  void paint(Canvas canvas, Size size) {
    double xOffset;
    // set Parameters for field side
    if (leftSide) {
      xOffset = 0;
    } else {
      xOffset = fieldSizeParameter.fieldWidth;
    }

    // draw bigger 9m oval
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(xOffset, fieldSizeParameter.fieldHeight / 2),
            width: fieldSizeParameter.nineMeterRadiusX * 2,
            height: fieldSizeParameter.nineMeterRadiusY * 2),
        Paint()..color = Colors.black);

    // draw smaller 6m oval
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(xOffset, fieldSizeParameter.fieldHeight / 2),
            width: fieldSizeParameter.sixMeterRadiusX * 2,
            height: fieldSizeParameter.sixMeterRadiusY * 2),
        Paint()..color = Colors.grey.shade300);

    // draw all sector borders by going through the lists containing gradient and y intersection
    for (int i = 0; i < fieldSizeParameter.gradients.length; i++) {
      /* To draw a line you need two points: (x1,y1) and (x2,y2)
      * (x1,y1) is given: x1 is xOffset (0 for left side, fieldWidth for right side) and y1 is the given y intercept.
      * (x2,y2) needs to be calculated: 
      * - for the left side we define x2=fieldWidth and put it into the given line equation (gradient*x2+y_intercept)
      * - for the right side we know gradient_right = -gradient_left and with this we calculate the y intercept.
      *    So we also have a line equation and can put x2 into it to get y2.
      */
      double x2;
      double y2;
      if (leftSide) {
        // left side
        x2 = fieldSizeParameter.fieldWidth;
        y2 = fieldSizeParameter.gradients[i] * x2 +
            fieldSizeParameter.yIntercepts[i];
      } else {
        // right side
        x2 = 0;
        num gradient = -fieldSizeParameter.gradients[i];
        num yIntercept = fieldSizeParameter.yIntercepts[i] - gradient * xOffset;
        y2 = gradient * x2 + yIntercept;
      }
      canvas.drawLine(Offset(xOffset, fieldSizeParameter.yIntercepts[i]),
          Offset(x2, y2), Paint()..color = Colors.blue);
    }
  }

  // Since this painter has no fields, it always paints
  // the same thing and semantics information is the same.
  // Therefore we return false here. If we had fields (set
  // from the constructor) then we would return true if any
  // of them differed from the same fields on the oldDelegate.
  @override
  bool shouldRepaint(FieldPainter oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(FieldPainter oldDelegate) => false;
}
