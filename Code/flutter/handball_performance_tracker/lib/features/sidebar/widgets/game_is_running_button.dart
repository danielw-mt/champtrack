import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:handball_performance_tracker/features/game/game.dart';

// Button which takes you back to the game
class GameIsRunningButton extends StatelessWidget {
  const GameIsRunningButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Back to Game Button
    return Container(
      decoration: BoxDecoration(
          color: buttonDarkBlueColor,
          // set border so corners can be made round
          border: Border.all(
            color: buttonDarkBlueColor,
          ),
          // make round edges
          borderRadius: BorderRadius.all(Radius.circular(MENU_RADIUS))),
      margin: EdgeInsets.only(left: 20, right: 20, top: 100),
      padding: EdgeInsets.all(10),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: buttonGreyColor,
          padding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(MENU_RADIUS),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_handball, color: buttonDarkBlueColor, size: 50),
            Expanded(
              child: Text(
                StringsGeneral.lBackToGameButton,
                style: TextStyle(color: buttonDarkBlueColor, fontSize: 18),
              ),
            )
          ],
        ),
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => GameView()));
        },
      ),
    );
  }
}
