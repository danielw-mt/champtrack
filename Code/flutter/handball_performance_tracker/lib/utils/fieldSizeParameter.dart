library fieldSizeParameter;

import 'dart:ui' as ui;

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
double toolbarHeight = AppBar().preferredSize.height;

// pixel size of border, 7m and 9m line
double lineSize = 3;

double fieldWidth = screenWidth * 0.7;
// fieldHeigt takes all available screen height -> substract height of toolbar, size of border*2 and padding due to time, battery indicator etc
double fieldHeight =
    screenHeight - toolbarHeight - paddingBottom - paddingTop - lineSize * 2;

// Radii of the ellipses for six meter and 9 meter
double nineMeterRadiusX = fieldWidth / 1.5;
double nineMeterRadiusY = fieldHeight / 2;

double sixMeterRadiusX = nineMeterRadiusX * 0.7;
double sixMeterRadiusY = nineMeterRadiusY * 0.7;

// List for gradients and y intercepts of the sector borders
List gradients = [1, 0.5, 0, -0.5, -1];
List yIntercepts = [
  fieldHeight / 2,
  fieldHeight / 2,
  fieldHeight / 2,
  fieldHeight / 2,
  fieldHeight / 2,
];
