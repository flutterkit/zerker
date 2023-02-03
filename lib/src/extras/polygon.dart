import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import '../node/node.dart';
import '../core/constant.dart';

class ZKPolygon extends ZKNode {
  @override
  String type = "ZKPolygon";
  Path? _path;
  int _count = 5;

  ////////////////////////////////////////////////////////////
  ///
  /// ZKPolygon constructor
  ///
  ////////////////////////////////////////////////////////////
  ZKPolygon(int count, double radius, [Color? color]) : super() {
    if (color != null) this.color = color;

    _path = Path();
    _count = count;
    _fillPath(count, radius);
  }

  void _fillPath(int count, double radius) {
    _path!.reset();

    double unit = (Constant.PI * 2) / count;
    for (int i = 0; i < count; i++) {
      double x = radius * cos(unit * i);
      double y = radius * sin(unit * i);

      if (i == 0)
        _path!.moveTo(x, y);
      else
        _path!.lineTo(x, y);
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
