import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import '../node/node.dart';
import '../core/constant.dart';

class ZKStar extends ZKNode {
  @override
  String type = "ZKStar";
  Path? _path;
  int _count = 5;

  ////////////////////////////////////////////////////////////
  ///
  /// ZKStar constructor
  ///
  ////////////////////////////////////////////////////////////
  ZKStar(int count, double radius, [Color? color]) : super() {
    if (color != null) this.color = color;
    _count = count;
    _path = Path();
    _fillPath(count, radius);
  }

  void _fillPath(int count, double radius) {
    _path!.reset();
    double n = count * 2;
    double r1 = radius;
    double r2 = count == 3 ? r1 * 0.35 : r1 * 0.5;
    double unit = (Constant.PI * 2) / n;
    double angle = 0;

    for (int i = 0; i < count; i++) {
      int a = 2 * i;
      int b = 2 * i + 1;
      // first point
      double x1 = r1 * cos(angle + a * unit);
      double y1 = r1 * sin(angle + a * unit);
      if (i == 0)
        _path!.moveTo(x1, y1);
      else
        _path!.lineTo(x1, y1);

      // second point
      double x2 = r2 * cos(angle + b * unit);
      double y2 = r2 * sin(angle + b * unit);
      _path!.lineTo(x2, y2);
    }
    _path!.close();
  }

  set radius(double radius) {
    _fillPath(_count, radius);
  }

  @override
  void draw(Canvas canvas, [Size? size]) {
    canvas.drawPath(_path!, this.paint);
  }
}
