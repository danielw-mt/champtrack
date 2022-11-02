import 'package:flutter/material.dart';

// returns the first line of the menu which is
// - the grey container
// - name of the Club
// - Arrows
class MenuHeader extends StatelessWidget {
  final String clubName;
  const MenuHeader({Key? key, required this.clubName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Header with Icon and Clubname
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon
        /*Container(
            decoration: BoxDecoration(
                color: buttonGreyColor,
                // set border so corners can be made round
                border: Border.all(
                  color: buttonGreyColor,
                ),
                // make round edges
                borderRadius: BorderRadius.all(Radius.circular(menuRadius))),
            margin: EdgeInsets.only(right: 20, left: 10, bottom: 15, top: 15),
            padding: EdgeInsets.all(10),
            child: Text(
              "HC",
            )),*/

        // Use FittedBox to dynamically resize text
        Expanded(
          child: FittedBox(
              fit: BoxFit.cover,
              child: Text(
                clubName,
                style: TextStyle(color: Colors.white),
              )),
        )
        // Arrow Icon
        //Container(margin: EdgeInsets.only(left: 20), child: Text(""))
      ],
    );
  }
}
