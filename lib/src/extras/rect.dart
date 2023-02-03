import 'dart:ui';
import 'package:flutter/material.dart';
import '../node/node.dart';

class ZKRect extends ZKNode {
  @override
  String type = "ZKRect";
  bool _center = false;

  ////////////////////////////////////////////////////////////
  ///
  /// ZKRect constructor
  ///
  ////////////////////////////////////////////////////////////
  ZKRect(double width, double height, [Color? color]) : super() {
    this.oriWidth = width;
    this.oriHeight = height;
    if (color != null) this.color = color;
  }

  void setCenter([bool center = true]) {
    _center = center;
  }

  void setScaleY(double scale) {
    setHeight(scale * oriHeight);
  }

  void setHeight(double height) {
    this.oriHeight = height;
  }

  @override
  void draw(Canvas canvas, [Size? size]) {
    if (_center) {
      canvas.drawRect(
          Rect.fromLTWH(-oriWidth / 2, -oriHeight / 2, oriWidth, oriHeight),
          this.paint);
    } else {
      canvas.drawRect(Rect.fromLTRB(0, 0, oriWidth, oriHeight), this.paint);
    }
  }
}
