import "dart:ui";
import "../animate/frame.dart";

abstract class BaseTexture {
  Image? image;

  String type = "";

  List<Frame> list = [];

  int get length;

  Size? get size;

  Frame? getFrame(dynamic key);

  void generateFrames();

  void setAllRectByClip(Rect clip) {
    for (int i = 0; i < list.length; i++) {
      list[i].setAllRectByClip(clip);
    }
  }

  String get version {
    return "0.1.0";
  }

  int get total {
    return length;
  }

  double get scale {
    return 1;
  }
}
