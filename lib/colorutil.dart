import 'package:flutter/material.dart';

enum SELECT_TIME { WEEK, MONTH }

class ColorUtil {
  static Color getBackGroundColor(int index) {
//    return Colors.pink.shade300;
    final value = index % 7;
    switch (value) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.blueAccent;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.deepPurple;
      case 4:
        return Colors.amber;
      case 5:
        return Colors.pink;
      case 6:
        return Colors.redAccent;
      default:
        return Color(0xff7797f2);
    }
  }
}
