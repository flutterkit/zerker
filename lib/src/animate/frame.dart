import "dart:ui";
import "dart:math";
import '../math/point.dart';
import '../math/mathutil.dart';
import '../core/constant.dart';

class Frame {
  Image image;
  String type;
  String name;

  Rect srcRect;
  Rect dstRect;
  bool trimmed;
  bool hasClip;
  Point anchor;

  bool rotated = false;
  bool _setted = false;

  dynamic info;
  Rect get rect => srcRect;

  Frame([String type, Image img]) {
    this.type = type;
    this.image = img;
  }

  double get width {
    return this.dstRect != null ? this.dstRect.width : 0;
  }

  double get height {
    return this.dstRect != null ? this.dstRect.height : 0;
  }

  bool get isEnabled {
    return image != null && dstRect != null;
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Set Anchor and Rect etc.
  ///
  ////////////////////////////////////////////////////////////
  /// set anchor
  void setAnchor(x, y) {
    this.anchor = Point(x * 1.0, y * 1.0);
  }

  void setSrcRect(l, t, w, h) {
    /// swap value
    if (this.rotated == true) {
      var c = w;
      w = h;
      h = c;
    }

    this.srcRect = Rect.fromLTWH(l * 1.0, t * 1.0, w * 1.0, h * 1.0);
  }

  void setDstRect(l, t, w, h) {
    /// swap value
    if (this.rotated == true) {
      var c = w;
      w = h;
      h = c;
    }

    this.dstRect =
        Rect.fromLTWH(l * 1.0, t * 1.0, w / Constant.ratio, h / Constant.ratio);
  }

  void rotateDstRectOnce(x, y) {
    if (this._setted != true) {
      var l = this.dstRect.left;
      var t = this.dstRect.top;
      var w = this.dstRect.width;
      var h = this.dstRect.height;

      List pos = this.coordinateRotate(x, y);
      var x1 = pos[0];
      var y1 = pos[1];

      this.dstRect = Rect.fromLTWH(l + (x - x1) * w, t + (y - y1) * h, w, h);
      this._setted = true;
    }
  }

  List coordinateRotate(x, y) {
    var cx = x;
    var cy = y;
    var x0 = y;
    var y0 = (1 - x);

    var point = MathUtil.coordinateRotate(-pi / 2, x0, y0, cx, cy);
    var x1 = MathUtil.round(point[0], 4);
    var y1 = MathUtil.round(point[1], 4);

    return [x1, y1];
  }

  /// set rect by clip & ratio
  void setAllRectByClip(Rect clip) {
    this.hasClip = true;
    this.srcRect = clip;
    this.dstRect = Rect.fromLTRB(
        0, 0, clip.width / Constant.ratio, clip.height / Constant.ratio);
  }

  String toString() {
    return "name:$name type:$type image:$image";
  }

  void dispose() {
    this.image = null;
    this.srcRect = null;
    this.dstRect = null;
    this.hasClip = false;
    this._setted = false;
  }
}
