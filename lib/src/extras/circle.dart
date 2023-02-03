import 'dart:ui';
import 'package:flutter/material.dart';
import '../node/node.dart';

class ZKCircle extends ZKNode {
  @override
  String type = "ZKCircle";

  double get radius {
    return _radius;
  }

  set radius(double r) {
    _radius = r;
    this._offset = Offset(oriWidth * this.anchor.x, oriHeight * this.anchor.y);
  }

  @override
  double get oriWidth {
    return 2 * radius;
  }

  @override
  double get oriHeight {
    return 2 * radius;
  }

  Offset _offset = Offset(0, 0);
  double _radius = 10;

  ////////////////////////////////////////////////////////////
  ///
  /// ZKCircle constructor
  ///
  ////////////////////////////////////////////////////////////
  ZKCircle(double radius, [Color? color]) : super() {
    this.radius = radius;
    if (color != null) this.color = color;
  }

  void setCenter(Offset offset) {
    _offset = offset;
  }

  @override
  void draw(Canvas canvas, [Size? size]) {
    canvas.drawCircle(_offset, radius, this.paint);
  }

  @override
  void reset() {
    super.reset();
    //radius = 10;
  }
}
