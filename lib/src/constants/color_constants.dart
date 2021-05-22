import 'package:flutter/material.dart';

class ColorConstants {
  ColorConstants();

  Color _aliveColor = Colors.purple[600];
  Color get aliveColor => _aliveColor;
  set setAliveColor(Color color) => _aliveColor = color;
}

ColorConstants colourConstants = ColorConstants();
