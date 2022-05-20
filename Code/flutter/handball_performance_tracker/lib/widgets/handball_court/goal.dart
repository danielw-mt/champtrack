import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Goal extends StatelessWidget {
  // widget to try out painting a goal using Custompainter
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CustomPaint(
        painter: GoalPainter(),
        child: SizedBox(
          width: 100,
          height: 100,
        ),
      ),
      onTap: () {
        print("custom painter tapped");
      },
    );
  }
}

class GoalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    // Path number 1

    paint.color = Color.fromARGB(255, 255, 0, 0);
    path = Path();
    path.lineTo(size.width * 6.7, size.height * 1.55);
    path.cubicTo(size.width * 6.49, size.height * 1.52, size.width * 6.26,
        size.height * 1.55, size.width * 6.09, size.height * 1.61);
    path.cubicTo(size.width * 5.95, size.height * 1.66, size.width * 5.86,
        size.height * 1.74, size.width * 5.79, size.height * 1.82);
    path.cubicTo(size.width * 5.74, size.height * 1.89, size.width * 5.7,
        size.height * 1.96, size.width * 5.7, size.height * 2.04);
    path.cubicTo(size.width * 5.7, size.height * 2.12, size.width * 5.73,
        size.height * 2.19, size.width * 5.79, size.height * 2.26);
    path.cubicTo(size.width * 5.88, size.height * 2.35, size.width * 6.01,
        size.height * 2.42, size.width * 6.17, size.height * 2.47);
    path.cubicTo(size.width * 6.33, size.height * 2.51, size.width * 6.51,
        size.height * 2.54, size.width * 6.7, size.height * 2.54);
    path.cubicTo(size.width * 6.7, size.height * 2.54, size.width * 6.7,
        size.height * 2.54, size.width * 6.7, size.height * 2.54);
    path.cubicTo(size.width * 6.7, size.height * 2.54, size.width * 6.7,
        size.height * 1.55, size.width * 6.7, size.height * 1.55);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
