import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/controllers/globalController.dart';

class SectorCalc {
  final GlobalController controller = Get.put(GlobalController());

  late double width;
  late double height;
  late double sixMeterRadiusX;
  late double sixMeterRadiusY;
  late double nineMeterRadiusX;
  late double nineMeterRadiusY;
  late double sector1Gradient;
  late double sector1Y;

  SectorCalc() {
    width = controller.fieldWith;
    height = controller.fieldHeight;
    sixMeterRadiusX = width / controller.sixMeterRadiusFactorX;
    sixMeterRadiusY = height / controller.sixMeterRadiusFactorY;
    nineMeterRadiusX = width / controller.nineMeterRadiusFactorX;
    nineMeterRadiusY = height / controller.nineMeterRadiusFactorY;
    sector1Gradient = controller.sector1Gradient;
    sector1Y = height / 2 + controller.sector1Y;
  }

  calculatePosition(Offset position) {
    double x = position.dx;
    double y = position.dy;

    if (inSectorOne(x, y)) {
      print("in Sector1");
    } else {
      print("not in Sector 1");
    }

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

  inSixMeterEllipse(double x, double y) {
    double yCentered = y - height / 2;
    return (x * x) / (sixMeterRadiusX * sixMeterRadiusX) +
            (yCentered * yCentered) / (sixMeterRadiusY * sixMeterRadiusY) <=
        1;
  }

  inNineMeterEllipse(double x, double y) {
    double yCentered = y - height / 2;
    return (x * x) / (nineMeterRadiusX * nineMeterRadiusX) +
            (yCentered * yCentered) / (nineMeterRadiusY * nineMeterRadiusY) <=
        1;
  }

  inSectorOne(double x, double y) {
    return sector1Gradient * x + sector1Y <= y;
  }
}

class FieldPainter extends CustomPainter {
  final GlobalController controller = Get.put(GlobalController());
  late double width;
  late double height;

  @override
  void paint(Canvas canvas, Size size) {
    width = controller.fieldWith;
    height = controller.fieldHeight;
    double sixMeterRadiusX = width / controller.sixMeterRadiusFactorX;
    double sixMeterRadiusY = height / controller.sixMeterRadiusFactorY;
    double nineMeterRadiusX = width / controller.nineMeterRadiusFactorX;
    double nineMeterRadiusY = height / controller.nineMeterRadiusFactorY;
    double sector1Gradient = controller.sector1Gradient;
    double sector1Y = height / 2 + controller.sector1Y;

    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(0.0, height / 2),
            width: nineMeterRadiusX * 2,
            height: nineMeterRadiusY * 2),
        Paint()..color = Colors.black);

    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(0.0, height / 2),
            width: sixMeterRadiusX * 2,
            height: sixMeterRadiusY * 2),
        Paint()..color = Colors.grey.shade300);

    double sector1P2X = (height - sector1Y) / sector1Gradient;
    canvas.drawLine(Offset(0.0, sector1Y), Offset(sector1P2X, height),
        Paint()..color = Colors.blue);
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
