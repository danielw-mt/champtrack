import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/controllers/fieldSizeParameter.dart'
    as fieldSizeParameter;

/* Class to calculate if a click was inside or outside a section.
* 
* @param  bool leftSide : true if we look at left field side
*         double xOffset : zero if we look at left field side, field width (max x value) if we look at right field side
*/
class SectorCalc {
  bool leftSide = true;
  late double xOffset;

  SectorCalc(this.leftSide) {
    if (leftSide) {
      xOffset = 0;
    } else {
      xOffset = fieldSizeParameter.fieldWidth;
    }
  }

  calculatePosition(Offset position) {
    double x = position.dx;
    double y = position.dy;

    inSector(x, y);
    if (inNineMeterEllipse(x, y)) {
      print("in 9m!");
    } else {
      print("not in 9m!");
    }

    if (inSixMeterEllipse(x, y)) {
      print("in 6m!");
    } else {
      print("not in 6m!");
    }
    print("");
  }

  /* Calculates if a point (x,y) is inside the smaller ellipse.
  * 
  * @return  true if (x,y) is inside and otherwise false.
  */
  inSixMeterEllipse(double x, double y) {
    double yCentered = y - fieldSizeParameter.fieldHeight / 2;
    double xCentered = x - xOffset;
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
  inNineMeterEllipse(double x, double y) {
    double yCentered = y - fieldSizeParameter.fieldHeight / 2;
    double xCentered = x - xOffset;
    return (xCentered * xCentered) /
                (fieldSizeParameter.nineMeterRadiusX *
                    fieldSizeParameter.nineMeterRadiusX) +
            (yCentered * yCentered) /
                (fieldSizeParameter.nineMeterRadiusY *
                    fieldSizeParameter.nineMeterRadiusY) <=
        1;
  }

  /* Calculates if a point (x,y) is below a sector border. 
  * This function has to be extended when the sector borders are decided!!
  */
  inSector(double x, double y) {
    for (int i = 0; i < fieldSizeParameter.gradients.length; i++) {
      double gradient;
      double yIntercept;
      if (leftSide) {
        // left side
        gradient = fieldSizeParameter.gradients[i];
        yIntercept = fieldSizeParameter.yIntercepts[i];
      } else {
        // right side
        gradient = -fieldSizeParameter.gradients[i];
        yIntercept = fieldSizeParameter.yIntercepts[i] - gradient * xOffset;
      }

      bool inSector = gradient * x + yIntercept <= y;
      print("is in Sector $i : $inSector");
    }
    return fieldSizeParameter.gradients[0] * x +
            fieldSizeParameter.yIntercepts[0] <=
        y;
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
        double gradient = -fieldSizeParameter.gradients[i];
        double yIntercept =
            fieldSizeParameter.yIntercepts[i] - gradient * xOffset;
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
