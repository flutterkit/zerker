import 'dart:ui';
import 'package:flutter/material.dart';
import '../node/node.dart';

class ZKRect extends ZKNode {
  @override
  String type = "ZKRect";

  ////////////////////////////////////////////////////////////
  ///
  /// ZKRect constructor
  ///
  ////////////////////////////////////////////////////////////
  ZKRect(double width, double height, [Color color]) : super() {
    this.oriWidth = width;
    this.oriHeight = height;
    if (color != null) this.color = color;
  }

  @override
  void draw(Canvas canvas, [Size size]) {
    canvas.drawRect(Rect.fromLTRB(0, 0, oriWidth, oriHeight), this.paint);
  }
}
