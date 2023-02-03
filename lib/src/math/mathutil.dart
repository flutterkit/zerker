import "dart:math";
import 'package:flutter/widgets.dart';

class MathUtil {
  static const double PI = 3.14159267;
  static const double PI_2 = PI / 2;
  static const double PIx2 = PI * 2;
  static const double PI_180 = PI / 180;
  static const double N180_PI = 180 / PI;

  static double round(double n, [int size = 4]) {
    num k = pow(10, size);
    return (n * k).round() / k;
  }

  static bool inA2B(val, double a, double b) {
    return val >= a && val <= b;
  }

  static List<double> coordinateRotate(
      double angle, double x, double y, double cx, double cy) {
    var x1 = (x - cx) * cos(angle) - (y - cy) * sin(angle) + cx;
    var y1 = (x - cx) * sin(angle) + (y - cy) * cos(angle) + cy;
    return [x1, y1];
  }

  static double getRandomA2B(double a, double b) {
    return Random().nextDouble() * (b - a) + a;
  }

  static Color getRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
        .withOpacity(1.0);
  }
}
