import 'package:flutter/material.dart';
import 'dart:math';

class ExpandMenuButton extends StatelessWidget {
  PageController pageController;
  ExpandMenuButton({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    Color buttonColor = Color.fromARGB(255, 180, 211, 236);
    // normal dialog button that has a shirt
    Column buttonContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Icon(
            Icons.add,
          ),
        ),
        // ButtonName
        Text(
          "Expand",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontSize: (MediaQuery.of(context).size.width * 0.02),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );

    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(color: buttonColor, borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: buttonContent,
        // have some space between the buttons
        margin: EdgeInsets.all(min(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width) * 0.013),
        // have round edges with same degree as Alert dialog
        // set height and width of buttons so the shirt and name are fitting inside
        height: MediaQuery.of(context).size.width * 0.14,
        width: MediaQuery.of(context).size.width * 0.14,
      ),
      onTap: () {
        pageController.nextPage(duration: Duration(milliseconds: 100), curve: Curves.ease);
      },
    );
  }
}
