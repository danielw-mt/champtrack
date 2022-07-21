library fieldSizeParameter;

import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/material.dart';

// Here are the parameter which describe the field (2 ellipses and sector borders).
// When the parameters are changed, the UI painting and calculation of coordinate positions are adapted automatically.

// Get width and height of UI
// physicalSize gives device pixels, devicePixelRatio gives number of device pixels for each logical pixel for the screen this view is displayed on.
double screenWidth = ui.window.physicalSize.width / ui.window.devicePixelRatio;
double screenHeight =
    ui.window.physicalSize.height / ui.window.devicePixelRatio;

// get size of upper bar with time, battery indicator etc
double paddingTop = ui.window.padding.top / ui.window.devicePixelRatio;
double paddingBottom = ui.window.padding.bottom / ui.window.devicePixelRatio;

// get toolbarHeight, so the field can take all the rest height of the screen
double toolbarHeight = AppBar().preferredSize.height * 1.3;

// pixel size of border, 7m and 9m line
double lineSize = 3;

// just a parameter for manually adjusting the height
double customHeightModifier = 0.99;
// fieldHeigt takes all available screen height -> substract height of toolbar, size of border*2 and padding due to time, battery indicator etc
double availableScreenHeight =
(screenHeight - toolbarHeight - paddingBottom - paddingTop - lineSize * 2);
// take ratio of screenwidth and height into account, so the field is not stretched
double fieldHeight = min(availableScreenHeight, screenWidth)*customHeightModifier;
double fieldWidth = fieldHeight;

// Radii of the ellipses for six meter and 9 meter
double nineMeterRadiusX = fieldWidth / 1.5;
double nineMeterRadiusY = fieldHeight / 2;

double sixMeterRadiusX = nineMeterRadiusX * 0.7;
double sixMeterRadiusY = nineMeterRadiusY * 0.7;

// goal width and height
double goalWidth = sixMeterRadiusX * 0.24;
double goalHeight = sixMeterRadiusX * 0.4;

// List for gradients and y intercepts of the sector borders
// To get the gradients its tan(angle) where angle is 20 degree and 55 degree here (to get 35 and 70 degree like in design).
List gradients = [1.43, 0.36, -0.36, -1.43];
List yIntercepts = [
  fieldHeight / 2,
  fieldHeight / 2,
  fieldHeight / 2,
  fieldHeight / 2,
];

// Set all sizes which are depending on field heigh and width.
void setFieldSize(double width, double heigh) {
  fieldHeight = heigh;
  fieldWidth = width;
  nineMeterRadiusX = fieldWidth / 1.5;
  nineMeterRadiusY = fieldHeight / 2;
  sixMeterRadiusX = nineMeterRadiusX * 0.7;
  sixMeterRadiusY = nineMeterRadiusY * 0.7;
  yIntercepts = [
    fieldHeight / 2,
    fieldHeight / 2,
    fieldHeight / 2,
    fieldHeight / 2,
  ];
}
