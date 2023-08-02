import "dart:math";
import 'package:flutter/widgets.dart';
import '../math/point.dart';
import '../math/mathutil.dart';

class ZKContext {
  Rect? rect;
  double ratio = 0.0;
  Offset? offset;
  dynamic expansion;

  Size? _size;
  Point _pos = Point(0, 0);

  Size get size {
    return _size!;
  }

  set size(Size s) {
    _size = s;
    rect = Rect.fromLTWH(0, 0, _size == null ? 0 : _size!.width,
        _size == null ? 0 : _size!.height);
  }

  double get screenWidth {
    // https://stackoverflow.com/questions/76312328/flutter-3-10-window-is-deprecated-and-shouldnt-be-used
    return WidgetsBinding
        .instance.platformDispatcher.views.first.physicalSize.width;
  }

  double get screenHeight {
    // ui.window.physicalSize
    return WidgetsBinding
        .instance.platformDispatcher.views.first.physicalSize.height;
  }

  double get appWidth {
    return this.size.width;
  }

  double get appHeight {
    return this.size.height;
  }

  double get deviceRatio {
    return WidgetsBinding
        .instance.platformDispatcher.views.first.devicePixelRatio;
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
    Size os =
        WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
    double ratio =
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    Size s = os / ratio;
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
