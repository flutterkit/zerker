////////////////////////////////////////////////////////////
///
/// Zerker's Matrix reference to the Matrix2D class from the Createjs framework,
/// thanks to the original author, good work!
///
/// URL: https://www.createjs.com/docs/easeljs/files/easeljs_geom_Matrix2D.js.html
///
////////////////////////////////////////////////////////////
import "dart:math";
import 'dart:typed_data';
import '../core/constant.dart';

class Matrix {
  double a = 1;
  double b = 0;
  double c = 0;
  double d = 1;
  double tx = 0;
  double ty = 0;

  Float64List matrix4;

  /// Represents an affine transformation matrix, and provides tools for constructing and concatenating matrices.
  /// This matrix can be visualized as:
  ///
  /// 	[ a  c  tx
  /// 	  b  d  ty
  /// 	  0  0  1  ]
  ///
  /// Note the locations of b and c.
  Matrix([double a = 1, double b = 0, double c = 0, double d = 1, double tx = 0, double ty = 0]) {
    this.a = a;
    this.b = b;
    this.c = c;
    this.d = d;
    this.tx = tx;
    this.ty = ty;
  }

  Matrix append([double a = 1, double b = 0, double c = 0, double d = 1, double tx = 0, double ty = 0]) {
    var a1 = this.a;
    var b1 = this.b;
    var c1 = this.c;
    var d1 = this.d;

    if (a != 1 || b != 0 || c != 0 || d != 1) {
      this.a = a1 * a + c1 * b;
      this.b = b1 * a + d1 * b;
      this.c = a1 * c + c1 * d;
      this.d = b1 * c + d1 * d;
    }

    this.tx = a1 * tx + c1 * ty + this.tx;
    this.ty = b1 * tx + d1 * ty + this.ty;
    return this;
  }

  Matrix prepend([double a = 1, double b = 0, double c = 0, double d = 1, double tx = 0, double ty = 0]) {
    var a1 = this.a;
    var c1 = this.c;
    var tx1 = this.tx;

    this.a = a * a1 + c * this.b;
    this.b = b * a1 + d * this.b;
    this.c = a * c1 + c * this.d;
    this.d = b * c1 + d * this.d;
    this.tx = a * tx1 + c * this.ty + tx;
    this.ty = b * tx1 + d * this.ty + ty;
    return this;
  }

  Matrix prependMatrix(Matrix matrix) {
    return this.prepend(matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);
  }

  Matrix appendMatrix(Matrix matrix) {
    return this.append(matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);
  }

  Matrix appendTransform(double x, double y, double scaleX, double scaleY, double rotation, double skewX, double skewY,
      double regX, double regY) {
    double cosa = 0;
    double sina = 0;

    if (rotation % 360 != 0) {
      var r = rotation * Constant.DEG_TO_RAD;
      cosa = cos(r);
      sina = sin(r);
    } else {
      cosa = 1;
      sina = 0;
    }

    if (skewX != 0 || skewY != 0) {
      skewX *= Constant.DEG_TO_RAD;
      skewY *= Constant.DEG_TO_RAD;
      this.append(cos(skewY), sin(skewY), -sin(skewX), cos(skewX), x, y);
      this.append(cosa * scaleX, sina * scaleX, -sina * scaleY, cosa * scaleY, 0, 0);
    } else {
      this.append(cosa * scaleX, sina * scaleX, -sina * scaleY, cosa * scaleY, x, y);
    }

    if (regX != 0 || regY != 0) {
      this.tx -= regX * this.a + regY * this.c;
      this.ty -= regX * this.b + regY * this.d;
    }

    return this;
  }

  Matrix prependTransform(double x, double y, double scaleX, double scaleY, double rotation, double skewX, double skewY,
      double regX, double regY) {
    double cosa = 0;
    double sina = 0;

    if (rotation % 360 != 0) {
      var r = rotation * Constant.DEG_TO_RAD;
      cosa = cos(r);
      sina = sin(r);
    } else {
      cosa = 1;
      sina = 0;
    }

    if (regX != 0 || regY != 0) {
      this.tx -= regX;
      this.ty -= regY;
    }
    if (skewX != 0 || skewY != 0) {
      skewX *= Constant.DEG_TO_RAD;
      skewY *= Constant.DEG_TO_RAD;
      this.prepend(cosa * scaleX, sina * scaleX, -sina * scaleY, cosa * scaleY, 0, 0);
      this.prepend(cos(skewY), sin(skewY), -sin(skewX), cos(skewX), x, y);
    } else {
      this.prepend(cosa * scaleX, sina * scaleX, -sina * scaleY, cosa * scaleY, x, y);
    }
    return this;
  }

  Matrix rotate(double angle) {
    double cosa = cos(angle);
    double sina = sin(angle);

    var a1 = this.a;
    var c1 = this.c;
    var tx1 = this.tx;

    this.a = a1 * cosa - this.b * sina;
    this.b = a1 * sina + this.b * cosa;
    this.c = c1 * cosa - this.d * sina;
    this.d = c1 * sina + this.d * cosa;
    this.tx = tx1 * cosa - this.ty * sina;
    this.ty = tx1 * sina + this.ty * cosa;
    return this;
  }

  Matrix skew(double skewX, double skewY) {
    skewX = skewX * Constant.DEG_TO_RAD;
    skewY = skewY * Constant.DEG_TO_RAD;
    this.append(cos(skewY), sin(skewY), -sin(skewX), cos(skewX), 0, 0);
    return this;
  }

  Matrix scale(double x, double y) {
    this.a *= x;
    this.d *= y;
    this.c *= x;
    this.b *= y;
    this.tx *= x;
    this.ty *= y;
    return this;
  }

  Matrix translate(double x, double y) {
    this.tx += x;
    this.ty += y;
    return this;
  }

  Matrix identity() {
    this.a = 1;
    this.b = 0;
    this.c = 0;
    this.d = 1;
    this.tx = 0;
    this.ty = 0;
    return this;
  }

  Matrix invert() {
    var a1 = this.a;
    var b1 = this.b;
    var c1 = this.c;
    var d1 = this.d;
    var tx1 = this.tx;
    var n = a1 * d1 - b1 * c1;

    this.a = d1 / n;
    this.b = -b1 / n;
    this.c = -c1 / n;
    this.d = a1 / n;
    this.tx = (c1 * this.ty - d1 * tx1) / n;
    this.ty = -(a1 * this.ty - b1 * tx1) / n;
    return this;
  }

  bool isIdentity() {
    return this.tx == 0 && this.ty == 0 && this.a == 1 && this.b == 0 && this.c == 0 && this.d == 1;
  }

  bool equals(Matrix matrix) {
    return this.tx == matrix.tx &&
        this.ty == matrix.ty &&
        this.a == matrix.a &&
        this.b == matrix.b &&
        this.c == matrix.c &&
        this.d == matrix.d;
  }

  Matrix clone() {
    return Matrix(this.a, this.b, this.c, this.d, this.tx, this.ty);
  }

  /// convert matrix3x3 to matrix4x4
  Float64List toMatrix4() {
    if (this.matrix4 == null) {
      this.matrix4 = Float64List.fromList(
          [this.a, this.b, 0.0, 0.0, this.c, this.d, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, this.tx, this.ty, 0.0, 1.0]);
    } else {
      this.matrix4[0] = this.a;
      this.matrix4[1] = this.b;
      this.matrix4[2] = 0.0;
      this.matrix4[3] = 0.0;
      this.matrix4[4] = this.c;
      this.matrix4[5] = this.d;
      this.matrix4[6] = 0.0;
      this.matrix4[7] = 0.0;
      this.matrix4[8] = 0.0;
      this.matrix4[9] = 0.0;
      this.matrix4[10] = 1.0;
      this.matrix4[11] = 0.0;
      this.matrix4[12] = this.tx;
      this.matrix4[13] = this.ty;
      this.matrix4[14] = 0.0;
      this.matrix4[15] = 1.0;
    }

    return this.matrix4;
  }

  String toString() {
    return '[ a:${a.toString()} b:${b.toString()} c:${c.toString()} d:${d.toString()} tx:${tx.toString()} ty:${ty.toString()} ]';
  }
}
