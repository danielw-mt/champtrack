import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';

class PlusButton extends StatelessWidget {
  const PlusButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: BUTTON_HEIGHT,
      child: TextButton(
        child: Icon(
          Icons.add,
          // Color of the +
          color: Color.fromARGB(255, 97, 97, 97),
          size: BUTTON_HEIGHT * 0.7,
        ),
        onPressed: () {
          Navigator.pop(context);
          // TODO call allplayers menu here
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          // make round button edges
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(BUTTON_RADIUS)),
          ),
        ),
      ),
    );
  }
}
