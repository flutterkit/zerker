import 'package:flutter/material.dart';
import 'package:zerker/zerker.dart';
import '../math/mathutil.dart';
import 'dart:math';

class ZKFlower extends ZKNode {
  @override
  String type = "ZKFlower";
  double radius = 10;
  Offset? _offset;

  ////////////////////////////////////////////////////////////
  ///
  /// ZKFlower constructor
  ///
  ////////////////////////////////////////////////////////////
  ZKFlower(double radius, [Color? color]) : super() {
    this.oriWidth = radius;
    this.oriHeight = radius;
    this._offset = Offset(0, 0);
    if (color != null) this.color = color;
  }

  @override
  void draw(Canvas canvas, [Size? size]) {
    double count = 5;
    double unit = MathUtil.PIx2 / count;
    double tha0 = rotation * MathUtil.PI_180;

    for (int i = 0; i < count; i++) {
      double tha = tha0 + unit * i;
      double x = radius * cos(tha);
      double y = radius * sin(tha);
      canvas.drawCircle(Offset(x, y), radius, this.paint);
    }

    canvas.drawCircle(_offset!, radius, this.paint);
  }
}
