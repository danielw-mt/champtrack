library fieldSizeParameter;

import 'dart:ui' as ui;

// Here are the parameter which describe the field (2 ellipses and sector borders).
// When the parameters are changed, the UI painting and calculation of coordinate positions are adapted automatically.

// Get width and height of UI
// physicalSize gives device pixels, devicePixelRatio gives number of device pixels for each logical pixel for the screen this view is displayed on.
double fieldWidth = ui.window.physicalSize.width / ui.window.devicePixelRatio;
double fieldHeight =
    ui.window.physicalSize.height * 0.8 / ui.window.devicePixelRatio;

// Radii of the ellipses for six meter and 9 meter
double sixMeterRadiusX = fieldWidth / 2;
double sixMeterRadiusY = fieldHeight / 3;
double nineMeterRadiusX = fieldWidth / 1.5;
double nineMeterRadiusY = fieldHeight / 2;

// List for gradients and y intercepts of the sector borders
List gradients = [1, 0.5, 0, -0.5, -1];
List yIntercepts = [
  fieldHeight / 2,
  fieldHeight / 2,
  fieldHeight / 2,
  fieldHeight / 2,
  fieldHeight / 2,
];
