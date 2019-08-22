import './container.dart';
import '../tween/ease.dart';
import '../tween/tween.dart';

class ZKScene extends ZKContainer {
  @override
  String type = "ZKScene";

  ////////////////////////////////////////////////////////////
  ///
  /// Admission/appearance animation - Fade in and out
  ///
  ////////////////////////////////////////////////////////////
  void fadeIn([int time = 1600, Function onComplete]) {
    this.alpha = 0;
    ZKTween(this).to({"alpha": 1}, time).easing(Ease.quart.easeOut).onComplete(onComplete).start();
  }

  void fadeOut([int time = 1000, Function onComplete]) {
    ZKTween(this).to({"alpha": 0}, time).easing(Ease.quart.easeIn).onComplete(onComplete).autoRemove().start();
  }
  
  ////////////////////////////////////////////////////////////
  ///
  /// Admission/appearance animation - Move in and out
  ///
  ////////////////////////////////////////////////////////////
  void moveIn({double x, double y, int time = 1600, Function onComplete, dynamic ease}) {
    this.alpha = 0;
    var oldPos = this.position.clone();
    this.position.x = x ?? this.position.x;
    this.position.y = y ?? this.position.y;

    ZKTween(this)
        .to({"alpha": 1, "x": oldPos.x, "y": oldPos.y}, time)
        .easing(ease ?? Ease.quart.easeOut)
        .onComplete(onComplete)
        .start();
  }

  void moveOut({double x, double y, int time = 1000, Function onComplete, dynamic ease}) {
    x = x ?? this.position.x;
    y = y ?? this.position.y;

    ZKTween(this)
        .to({"alpha": 0, "x": x, "y": y}, time)
        .easing(ease ?? Ease.quart.easeIn)
        .onComplete(onComplete)
        .autoRemove()
        .start();
  }
}
