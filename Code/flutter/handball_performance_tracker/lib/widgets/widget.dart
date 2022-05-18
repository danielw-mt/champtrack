import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/utils/helper.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CoordinateDetector extends StatelessWidget {
  const CoordinateDetector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.8,

      //   child: GestureDetector(
      // onTapDown: (TapDownDetails details) => Score().calculatePosition(details.localPosition), //print(details.globalPosition),
      //     child: ClipPath(
      //         child: Stack(children: <Widget>[
      //       Container(
      //       CustomPaint(painter: PathPainter(path))
      //     ]),
      //     clipper: PathClipper(path)));

      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          // image: svgPicture.asset("assets/feld_rechts.svg"),
          image: NetworkImage("assets/feld_links.png"),
        ),
      ),
      child: GestureDetector(
        onTapDown: (TapDownDetails details) => Score().calculatePosition(
            details.localPosition), //print(details.globalPosition),
      ),
    );

    // child: SvgPicture.network("assets/feld_rechts.svg"),
    // );
  }
}
