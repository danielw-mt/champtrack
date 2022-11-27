import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';

class CustomAlertMessageWidget extends StatelessWidget {
  late final String alertMessage;
  CustomAlertMessageWidget(alertMessage) : alertMessage = alertMessage;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(color: popupGreyColor, borderRadius: BorderRadius.circular(10.0)),
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
              child: Icon(Icons.error_outline, color: buttonDarkBlueColor, size: 60),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 25.0),
            child: Center(
              child: DefaultTextStyle(
                // use DefaultTextStyle so there are no yellow underlines
                style: TextStyle(),
                child: Text(
                  alertMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
