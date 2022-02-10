import 'package:flutter/material.dart';

class HexColor extends Color {
  HexColor(final String code) : super(_hexToColor(code));

  static int _hexToColor(String code) {
    return int.parse(code.substring(1, 7), radix: 16) + 0xFF000000;
  }
}
