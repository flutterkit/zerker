import "dart:math";
import 'package:flutter/material.dart';

import "./node.dart";
import "../utils/util.dart";
import "../utils/listmap.dart";

class ZKGraphic extends ZKNode {
  Paint? _currentPaint;
  ListMap _drawList = new ListMap();
  double _alpha = 1;

  @override
  bool interactive = false;

  @override
  String type = "ZKGraphic";

  ZKGraphic() : super() {
    //this._drawList = new ListMap();
    this.anchor.set(0.0, 0.0);
  }

  @override
  void createPaint() {
    _currentPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Setter and Getter methods
  ///
  ////////////////////////////////////////////////////////////
  @override
  set alpha(double a) {
    if (a < 0) return;
    if (this.alpha == a) return;

    _alpha = max(0, min(a, 1));
    this._drawList.forEach((item, id) {
      Paint paint = item["paint"];
      paint.color = paint.color.withOpacity(_alpha);
      // if (paint.color != null) {
      // } else {
      //   paint.color = Colors.white.withOpacity(_alpha);
      // }
    });
  }

  double get alpha {
    return this._alpha;
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Various drawing related Apis
  ///
  ////////////////////////////////////////////////////////////
  void drawArc(double x, double y, double r, double sAngle, double eAngle,
      [bool useCenter = true]) {
    var rect = Rect.fromCircle(center: Offset(x, y), radius: r);
    this._addDrawList("drawArc", rect, sAngle, eAngle, useCenter);
  }

  void drawOval(double x, double y, double w, double h) {
    var rect = Rect.fromPoints(Offset(x, y), Offset(w, h));
    this._addDrawList("drawOval", rect);
  }

  void drawRect(double x, double y, double w, double h) {
    this._addDrawList("drawRect", Rect.fromLTRB(x, y, x + w, y + h));
  }

  void drawCircle(double x, double y, double radius) {
    this._addDrawList("drawCircle", Offset(x, y), radius);
  }

  void drawTriangle(
      double x1, double y1, double x2, double y2, double x3, double y3) {
    Path path = new Path();
    path.moveTo(x1, y1);
    path.lineTo(x2, y2);
    path.lineTo(x3, y3);
    this._addDrawList("drawTriangle", path);
  }

  void drawLine(double x1, double y1, double x2, double y2) {
    this._addDrawList("drawLine", Offset(x1, y1), Offset(x2, y2));
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Set the style of the derivative method
  ///
  ////////////////////////////////////////////////////////////
  void setStyle(
      {BlendMode? blendMode,
      Color? color,
      ColorFilter? colorFilter,
      FilterQuality? filterQuality,
      bool? invertColors,
      bool? isAntiAlias,
      StrokeCap? strokeCap,
      StrokeJoin? strokeJoin,
      double? strokeMiterLimit,
      double? strokeWidth,
      PaintingStyle? style}) {
    _currentPaint = Paint();
    if (color != null) _currentPaint?.color = color;
    if (blendMode != null) _currentPaint?.blendMode = blendMode;
    if (colorFilter != null) _currentPaint?.colorFilter = colorFilter;
    if (filterQuality != null) _currentPaint?.filterQuality = filterQuality;
    if (invertColors != null) _currentPaint?.invertColors = invertColors;
    if (isAntiAlias != null) _currentPaint?.isAntiAlias = isAntiAlias;
    if (strokeCap != null) _currentPaint?.strokeCap = strokeCap;
    if (strokeJoin != null) _currentPaint?.strokeJoin = strokeJoin;
    if (strokeWidth != null) _currentPaint?.strokeWidth = strokeWidth;
    if (style != null) _currentPaint?.style = style;
    if (strokeMiterLimit != null)
      _currentPaint?.strokeMiterLimit = strokeMiterLimit;
  }

  void clear() {
    this._drawList.clear();
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Native drawing graphic function
  ///
  ////////////////////////////////////////////////////////////
  @override
  draw(Canvas canvas, [Size? size]) {
    this._drawList.forEach(drawShape);
  }

  drawShape(item, id) {
    switch (item["methodName"]) {
      case "drawRect":
        {
          canvas?.drawRect(item["parm1"], item["paint"]);
        }
        break;

      case "drawCircle":
        {
          canvas?.drawCircle(item["parm1"], item["parm2"], item["paint"]);
        }
        break;

      case "drawOval":
        {
          canvas?.drawOval(item["parm1"], item["paint"]);
        }
        break;

      case "drawArc":
        {
          canvas?.drawArc(item["parm1"], item["parm2"], item["parm3"],
              item["parm4"], item["paint"]);
        }
        break;

      case "drawTriangle":
        {
          canvas?.drawPath(item["parm1"], item["paint"]);
        }
        break;

      case "drawLine":
        {
          canvas?.drawLine(item["parm1"], item["parm2"], item["paint"]);
        }
        break;

      default:
        {
          /// statements;
        }
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    this.clear();

    _currentPaint = null;
  }

  void _addDrawList(String methodName,
      [dynamic parm1,
      dynamic parm2,
      dynamic parm3,
      dynamic parm4,
      dynamic parm5]) {
    var id = Util.uuid();
    this._drawList.add(id, {
      "id": id,
      "paint": _currentPaint,
      "methodName": methodName,
      "parm1": parm1,
      "parm2": parm2,
      "parm3": parm3,
      "parm4": parm4,
      "parm5": parm5
    });
  }
}
