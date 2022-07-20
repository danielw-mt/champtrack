import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class CustomAlertWidget extends StatelessWidget {
  late final String alertMessage;

  CustomAlertWidget(alertMessage) : alertMessage = alertMessage;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          color: popupGreyColor, borderRadius: BorderRadius.circular(10.0)),
      width: 0.5 * height,
      height: 0.3 * width,
      alignment: AlignmentDirectional.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                  strokeWidth: 7.0, color: buttonDarkBlueColor),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 25.0),
            child: Center(
              child: Text(
                alertMessage,
                style: TextStyle(
                  color: Colors.grey.shade800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
