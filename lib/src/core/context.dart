import "dart:math";
import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import '../math/point.dart';
import '../math/mathutil.dart';

class ZKContext {
  Rect rect;
  double ratio;
  Offset offset;
  dynamic expansion;

  Size _size;
  Point _pos = Point(0, 0);

  Size get size {
    return _size;
  }

  set size(Size s) {
    _size = s;
    rect = Rect.fromLTWH(0, 0, _size == null ? 0 : _size.width,
        _size == null ? 0 : _size.height);
  }

  double get screenWidth {
    return ui.window.physicalSize.width;
  }

  double get screenHeight {
    return ui.window.physicalSize.height;
  }

  double get appWidth {
    return this.size.width;
  }

  double get appHeight {
    return this.size.height;
  }

  double get deviceRatio {
    return ui.window.devicePixelRatio;
  }

  double get appWidthDP {
    return screenWidth / deviceRatio;
  }

  double get appHeightDP {
    return screenHeight / deviceRatio;
  }

  Color getRandomColor() {
    return MathUtil.getRandomColor();
  }

  bool isLandscape() {
    Size s = ui.window.physicalSize / ui.window.devicePixelRatio;
    bool landscape = s.width > s.height;
    return landscape;
  }

  double getRandomA2B(double a, double b) {
    return MathUtil.getRandomA2B(a, b);
  }

  Point getRandomPosition() {
    _pos.x = size.width * (Random().nextDouble());
    _pos.y = size.height * (Random().nextDouble());
    return _pos;
  }
}
