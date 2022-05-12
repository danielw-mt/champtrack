import 'package:flutter/material.dart';
import 'screens/mainScreen.dart';

void main() {
  runApp(MaterialApp(
    title: 'Handball Performance Tracker',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home:mainScreen()));
}
