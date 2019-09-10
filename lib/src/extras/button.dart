import 'dart:ui';
import '../node/image.dart';
import '../node/container.dart';
import '../event/event.dart';
import '../tween/ease.dart';
import '../tween/tween.dart';

class ZKButton extends ZKContainer {
  @override
  String type = "ZKButton";

  Paint strokePaint = Paint()..style = PaintingStyle.stroke;
  Function onTap;
  ZKImage _btn;

  ////////////////////////////////////////////////////////////
  ///
  /// ZKButton constructor
  ///
  ////////////////////////////////////////////////////////////
  ZKButton(String url) : super() {
    this._btn = ZKImage(url);
    this.addChild(this._btn);
    this._addEventListener();
  }

  void _addEventListener() {
    _btn.onTapDown = (ZKEvent event) {
      ZKTween(_btn)
          .to({"scaleX": 1.1, "scaleY": 1.1}, 400)
          .easing(Ease.quad.easeOut)
          .start();
    };

    _btn.onTapUp = (ZKEvent event) {
      if (onTap != null) onTap();
      if (onTapUp != null) onTapUp(event);
      ZKTween(_btn)
          .to({"scaleX": 1, "scaleY": 1}, 400)
          .easing(Ease.quad.easeIn)
          .start();
    };

    _btn.onLoad = (dynamic path) {
      this.oriWidth = _btn.oriWidth;
      this.oriHeight = _btn.oriHeight;
      _btn.position.x = center.dx;
      _btn.position.y = center.dy;
    };
  }

  @override
  set debug(bool d) {
    _btn.debug = d;
  }

  @override
  void dispose() {
    super.dispose();

    onTap = null;
    _btn.dispose();
    _btn.onLoad = null;
  }
}
