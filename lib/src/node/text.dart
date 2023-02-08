import 'package:flutter/material.dart';
import './node.dart';

class ZKText extends ZKNode {
  TextPainter? _painter;
  TextStyle? _style;
  TextSpan? _span;
  bool _layouted = false;
  Offset _offset = new Offset(0, 0);

  @override
  String type = "ZKText";

  @override
  bool interactive = false;

  @override
  void createPaint() {
    this.createStyle();
    this.createTextSpan();
    this.createTextPainter();
    this.layout();
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Create TextStyle TextSpan and TextPainter
  ///
  ////////////////////////////////////////////////////////////
  TextStyle? createStyle() {
    _style = TextStyle(inherit: false, color: Colors.blue, fontSize: 16.0);
    return _style;
  }

  TextSpan? createTextSpan([String t = ""]) {
    _span = new TextSpan(text: t, style: _style);
    return _span;
  }

  TextPainter? createTextPainter() {
    _painter = new TextPainter(
        text: _span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    return _painter;
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Setter and Getter Methods
  ///
  ////////////////////////////////////////////////////////////
  @override
  set alpha(double a) {
    print("Zerker:: Sorry, ZKText does not currently support alpha attribute.");
  }

  @override
  double get oriWidth {
    return _layouted ? this._painter!.width : 0;
  }

  @override
  double get oriHeight {
    return _layouted ? this._painter!.height : 0;
  }

  String get text {
    return _span != null ? _span!.text ?? "" : "";
  }

  set text(String t) {
    this.setText(t);
  }

  TextStyle? get style {
    return _style;
  }

  set style(TextStyle? s) {
    _style = s;
    this.setText(this.text);
  }

  TextPainter? get painter {
    return _painter;
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Set the style of the derivative method
  ///
  ////////////////////////////////////////////////////////////
  void setStyle(
      {bool inherit: false,
      Color color: Colors.blue,
      Color? backgroundColor,
      double fontSize: 16.0,
      FontWeight? fontWeight,
      FontStyle? fontStyle,
      double? letterSpacing,
      double? wordSpacing,
      double? height,
      Paint? background,
      List<Shadow>? shadows,
      TextDecoration? decoration,
      Color? decorationColor,
      TextDecorationStyle? decorationStyle,
      double? decorationThickness,
      String? fontFamily,

      /// text pos style
      TextAlign textAlign: TextAlign.center,
      TextDirection textDirection: TextDirection.ltr,
      double textScaleFactor: 1.0,
      int? maxLines,
      String? ellipsis,
      StrutStyle? strutStyle,
      TextWidthBasis textWidthBasis: TextWidthBasis.parent}) {
    _style = _style?.merge(TextStyle(
      inherit: inherit,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      height: height,
      shadows: shadows,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    ));

    this.setPainterStyle(
        textAlign: textAlign,
        textDirection: textDirection,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines,
        ellipsis: ellipsis,
        strutStyle: strutStyle,
        textWidthBasis: textWidthBasis);
  }

  void setPainterStyle(
      {TextAlign textAlign: TextAlign.center,
      TextDirection textDirection: TextDirection.ltr,
      double textScaleFactor: 1.0,
      int? maxLines,
      String? ellipsis,
      StrutStyle? strutStyle,
      TextWidthBasis textWidthBasis: TextWidthBasis.parent}) {
    _painter?.textAlign = textAlign;
    _painter?.textDirection = textDirection;
    _painter?.textScaleFactor = textScaleFactor;
    _painter?.maxLines = maxLines;
    _painter?.ellipsis = ellipsis;
    _painter?.strutStyle = strutStyle;
    _painter?.textWidthBasis = textWidthBasis;

    this.setText(this.text);
  }

  void layout() {
    _painter?.layout();
    _layouted = true;
  }

  void setText(String t) {
    _painter?.text = this.createTextSpan(t);
    this.layout();
  }

  void setColor(Color color) {
    _style = _style!.merge(TextStyle(color: color));
  }

  void setFontFamily(String fontFamily) {
    _style = _style!.merge(TextStyle(fontFamily: fontFamily));
  }

  void setFontSize(double fontSize) {
    _style = _style!.merge(TextStyle(fontSize: fontSize));
  }

  void refresh() {
    this.setText(this.text);
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Update, render and other related functions
  ///
  ////////////////////////////////////////////////////////////
  @override
  void draw(Canvas canvas, [Size? size]) {
    _painter!.paint(canvas, _offset);
  }

  @override
  void dispose() {
    super.dispose();

    _painter = null;
    _style = null;
    _span = null;
  }
}
