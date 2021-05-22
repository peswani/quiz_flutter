import 'package:flutter/cupertino.dart';

class AnimationCalculation {
  final GlobalKey key;
  double width = 0.0;
  double height = 0.0;

  final double scaledWidthHeight = 150;

  AnimationCalculation(this.key) {
    _calculateDeviceMatrix();
  }

  _calculateDeviceMatrix() {
    width = MediaQuery.of(this.key.currentContext!).size.width;
    height = MediaQuery.of(this.key.currentContext!).size.height;
    print("width : $width height : $height");
  }

  Offset getPositions() {
    final RenderBox renderBoxRed =
        key.currentContext!.findRenderObject() as RenderBox;
    final positionRed = renderBoxRed.localToGlobal(Offset.zero);
    print("POSITION of : $positionRed ");

    final dx = positionRed.dx - width / 2 - scaledWidthHeight / 2;
    print(dx);
    final a = (scaledWidthHeight + dx) / scaledWidthHeight;
    final dy = positionRed.dy - height / 2 - scaledWidthHeight / 2;
    final b = (scaledWidthHeight + dy) / scaledWidthHeight;
    print("dx : $a ,  dy : $b");
    return Offset(-a, -b);
    // return scaledOffset / 60;
    // final dx = width-
  }
}
