// import 'package:flutter/material.dart';
// import 'package:handball_performance_tracker/core/constants/colors.dart';
// import 'package:handball_performance_tracker/core/constants/positions.dart';
// import 'package:handball_performance_tracker/data/models/models.dart';
// import 'package:handball_performance_tracker/features/game/bloc/game_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:handball_performance_tracker/core/constants/field_size_parameters.dart' as fieldSizeParameter;
// import 'package:handball_performance_tracker/old-utils/player_helper.dart';
// import 'dart:math';
// import 'player_bar.dart';
// // TODO do we need this package?
// import 'package:rainbow_color/rainbow_color.dart';

// class PlusButton extends StatelessWidget {
//   const PlusButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     void popupAllPlayer() {
//       List<Container> buttons = [];
//       for (int i in getNotOnFieldIndex()) {
//         Container button = buildPopupPlayerButton(context, i);
//         buttons.add(button);
//       }
//       showPopup(context, buttons, i);
//     }

//     return Container(
//       height: buttonHeight,
//       child: TextButton(
//         child: Icon(
//           Icons.add,
//           // Color of the +
//           color: Color.fromARGB(255, 97, 97, 97),
//           size: buttonHeight * 0.7,
//         ),
//         onPressed: () {
//           plusPressed = true;
//           Navigator.pop(context);
//           popupAllPlayer();
//         },
//         style: TextButton.styleFrom(
//           backgroundColor: buttonColor,
//           // make round button edges
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(buttonRadius)),
//           ),
//         ),
//       ),
//     );
//   }
// }
