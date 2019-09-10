import 'package:flutter/gestures.dart';

class ZKEvent {
  dynamic details;
  dynamic target;

  double get dx {
    return local != null ? local.dx : 0.0;
  }

  double get dy {
    return local != null ? local.dy : 0.0;
  }

  Offset get local {
    return details != null ? details?.localPosition : null;
  }

  Offset get global {
    return details != null ? details?.globalPosition : null;
  }

  ZKEvent.fromDetails(dynamic d) {
    details = d;
  }

  String toString() {
    return '[ dx:${dx.toString()}, dy:${dy.toString()} ]';
  }
}
