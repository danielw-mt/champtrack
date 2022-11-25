import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/constants/fieldSizeParameter.dart' as fieldSizeParameter;
import 'dart:math' as math;
import 'dart:ui' as ui;

/* Class that paints the fiels, this means two ovals and sector borders as determined in fieldSizeParameter.dart.
* 
* @param  bool leftSide : true if we look at left field side
*/
class FieldPainter extends CustomPainter {
  bool leftSide = true;
  Color nineMeterColor;
  Color sixMeterColor;
  Color fieldBackgroundColor;
  FieldPainter(this.leftSide, this.nineMeterColor, this.sixMeterColor, this.fieldBackgroundColor);


  @override
  void paint(Canvas canvas, Size size) {
    double xOffset;
    double startAngle;
    double sweepAngle;
    double goalOffset;
    // set Parameters for field side
    if (leftSide) {
      xOffset = 0;
      startAngle = math.pi / 2;
      sweepAngle = -math.pi;
      goalOffset = xOffset + fieldSizeParameter.goalWidth / 2;
    } else {
      xOffset = fieldSizeParameter.fieldWidth;
      startAngle = math.pi / 2;
      sweepAngle = math.pi;
      goalOffset = xOffset - fieldSizeParameter.goalWidth / 2;
    }
    // draw background
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(fieldSizeParameter.fieldWidth / 2, fieldSizeParameter.fieldHeight / 2),
            width: fieldSizeParameter.fieldWidth,
            height: fieldSizeParameter.fieldHeight),
        Paint()..color = fieldBackgroundColor);

    // draw bigger 9m oval
    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(xOffset, fieldSizeParameter.fieldHeight / 2),
            width: fieldSizeParameter.nineMeterRadiusX * 2,
            height: fieldSizeParameter.nineMeterRadiusY * 2),
        startAngle,
        sweepAngle,
        false,
        Paint()..color = nineMeterColor);

    // draw smaller 6m oval
    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(xOffset, fieldSizeParameter.fieldHeight / 2),
            width: fieldSizeParameter.sixMeterRadiusX * 2,
            height: fieldSizeParameter.sixMeterRadiusY * 2),
        startAngle,
        sweepAngle,
        false,
        Paint()..color = sixMeterColor);

    // draw 7m line
    // To draw a line you need two points: (x1,y1) and (x2,y2)
    double x1;
    double x2;
    // difference between y1 and y2 determines the length of the 7m line.
    double yDifferenceFactor = 0.035;
    double y1 = fieldSizeParameter.fieldHeight / 2 - fieldSizeParameter.fieldHeight * yDifferenceFactor;
    double y2 = fieldSizeParameter.fieldHeight / 2 + fieldSizeParameter.fieldHeight * yDifferenceFactor;
    if (leftSide) {
      x1 = (fieldSizeParameter.sixMeterRadiusX * 2 + fieldSizeParameter.nineMeterRadiusX) / 3;
      x2 = x1;
    } else {
      x1 = fieldSizeParameter.fieldWidth - (fieldSizeParameter.sixMeterRadiusX * 2 + fieldSizeParameter.nineMeterRadiusX) / 3;
      x2 = x1;
    }
    canvas.drawLine(
        Offset(x1, y1),
        Offset(x2, y2),
        Paint()
          ..color = Colors.black
          ..strokeWidth = fieldSizeParameter.lineSize);

    // draw goal
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(goalOffset, fieldSizeParameter.fieldHeight / 2),
            width: fieldSizeParameter.goalWidth,
            height: fieldSizeParameter.goalHeight),
        Paint()..color = nineMeterColor);
  }

  // If we have fields (set from the constructor) that are different than the old state 
  // then repaint (thats why we return true) because the differ from the oldDelegate.
  @override
  bool shouldRepaint(FieldPainter oldDelegate) => true;

  // Since this painter has no fields, it always paints
  // the same thing and semantics information is the same.
  // Therefore we return false here.
  @override
  bool shouldRebuildSemantics(FieldPainter oldDelegate) => false;
}

// Code for the dased Oval line, taken from here:
// https://stackoverflow.com/questions/54019785/how-to-add-line-dash-in-flutter (25.05.22)
class DashedPathPainter extends CustomPainter {
  late Path originalPath;
  bool isEllipse; // false for goal rectangle
  final Color pathColor;
  final double strokeWidth = fieldSizeParameter.lineSize;
  final double dashGapLength;
  final double dashLength;
  late DashedPathProperties _dashedPathProperties;
  bool leftSide = true;

  DashedPathPainter({
    required this.leftSide,
    required this.isEllipse,
    this.pathColor = Colors.black,
    this.dashGapLength = 7,
    this.dashLength = 7.3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double xOffset;
    double goalOffset;
    double startAngle;
    double sweepAngle;
    // set Parameters for field side
    if (leftSide) {
      xOffset = 0;
      startAngle = math.pi / 2;
      sweepAngle = -math.pi;
      goalOffset = xOffset + fieldSizeParameter.goalWidth / 2;
    } else {
      xOffset = fieldSizeParameter.fieldWidth;
      startAngle = math.pi / 2;
      sweepAngle = math.pi;
      goalOffset = xOffset - fieldSizeParameter.goalWidth / 2;
    }

    if (isEllipse) {
      // definde 9m oval
      originalPath = Path()
        ..addArc(
          Rect.fromCenter(
              center: Offset(xOffset, fieldSizeParameter.fieldHeight / 2),
              width: fieldSizeParameter.nineMeterRadiusX * 2,
              height: fieldSizeParameter.nineMeterRadiusY * 2),
          startAngle,
          sweepAngle,
        );
    } else {
      originalPath = Path()
        ..addRect(
          Rect.fromCenter(
              center: Offset(goalOffset, fieldSizeParameter.fieldHeight / 2),
              width: fieldSizeParameter.goalWidth,
              height: fieldSizeParameter.goalHeight),
        );
    }
    _dashedPathProperties = DashedPathProperties(
      path: Path(),
      dashLength: dashLength,
      dashGapLength: dashGapLength,
    );
    final dashedPath = _getDashedPath(originalPath, dashLength, dashGapLength);
    canvas.drawPath(
      dashedPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = pathColor
        ..strokeWidth = strokeWidth,
    );
  }

  @override
  bool shouldRepaint(DashedPathPainter oldDelegate) => false;

  Path _getDashedPath(
    Path originalPath,
    double dashLength,
    double dashGapLength,
  ) {
    final metricsIterator = originalPath.computeMetrics().iterator;
    while (metricsIterator.moveNext()) {
      final metric = metricsIterator.current;
      _dashedPathProperties.extractedPathLength = 0.0;
      while (_dashedPathProperties.extractedPathLength < metric.length) {
        if (_dashedPathProperties.addDashNext) {
          _dashedPathProperties.addDash(metric, dashLength);
        } else {
          _dashedPathProperties.addDashGap(metric, dashGapLength);
        }
      }
    }
    return _dashedPathProperties.path;
  }
}

class DashedPathProperties {
  double extractedPathLength;
  Path path;

  final double _dashLength;
  double _remainingDashLength;
  double _remainingDashGapLength;
  bool _previousWasDash;

  DashedPathProperties({
    required this.path,
    required double dashLength,
    required double dashGapLength,
  })  : assert(dashLength > 0.0, 'dashLength must be > 0.0'),
        assert(dashGapLength > 0.0, 'dashGapLength must be > 0.0'),
        _dashLength = dashLength,
        _remainingDashLength = dashLength,
        _remainingDashGapLength = dashGapLength,
        _previousWasDash = false,
        extractedPathLength = 0.0;

  bool get addDashNext {
    if (!_previousWasDash || _remainingDashLength != _dashLength) {
      return true;
    }
    return false;
  }

  void addDash(ui.PathMetric metric, double dashLength) {
    // Calculate lengths (actual + available)
    final end = _calculateLength(metric, _remainingDashLength);
    final availableEnd = _calculateLength(metric, dashLength);
    // Add path
    final pathSegment = metric.extractPath(extractedPathLength, end);
    path.addPath(pathSegment, Offset.zero);
    // Update
    final delta = _remainingDashLength - (end - extractedPathLength);
    _remainingDashLength = _updateRemainingLength(
      delta: delta,
      end: end,
      availableEnd: availableEnd,
      initialLength: dashLength,
    );
    extractedPathLength = end;
    _previousWasDash = true;
  }

  void addDashGap(ui.PathMetric metric, double dashGapLength) {
    // Calculate lengths (actual + available)
    final end = _calculateLength(metric, _remainingDashGapLength);
    final availableEnd = _calculateLength(metric, dashGapLength);
    // Move path's end point
    ui.Tangent tangent = metric.getTangentForOffset(end)!;
    path.moveTo(tangent.position.dx, tangent.position.dy);
    // Update
    final delta = end - extractedPathLength;
    _remainingDashGapLength = _updateRemainingLength(
      delta: delta,
      end: end,
      availableEnd: availableEnd,
      initialLength: dashGapLength,
    );
    extractedPathLength = end;
    _previousWasDash = false;
  }

  double _calculateLength(ui.PathMetric metric, double addedLength) {
    return math.min(extractedPathLength + addedLength, metric.length);
  }

  double _updateRemainingLength({
    required double delta,
    required double end,
    required double availableEnd,
    required double initialLength,
  }) {
    return (delta > 0 && availableEnd == end) ? delta : initialLength;
  }
}
