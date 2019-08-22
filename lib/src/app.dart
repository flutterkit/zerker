import 'package:flutter/widgets.dart';

import './core/constant.dart';
import './core/context.dart';
import './event/event.dart';
import './node/stage.dart';
import "./utils/util.dart";
import "./math/point.dart";

class ZKApp {
  String type = "ZKApp";
  String id = Util.uuid();

  Function onDispose;
  bool interactive = false;
  bool destroyed = false;
  bool clip = false;
  int fps = 60;

  ZKStage stage;

  ZKApp() {
    this.stage = new ZKStage();
    this.stage.context = new ZKContext();
  }

  ZKContext get context {
    return this?.stage?.context;
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Setter and Getter Function
  ///
  ////////////////////////////////////////////////////////////
  set ratio(double r) {
    Constant.ratio = r;
  }

  double get ratio {
    return Constant.ratio;
  }

  Size get size {
    return this.context?.size;
  }

  double get appWidth {
    return this.context?.appWidth;
  }

  double get appHeight {
    return this.context?.appHeight;
  }

  Color getRandomColor() {
    return this.context?.getRandomColor();
  }

  double getRandomA2B(double a, double b) {
    return this.context.getRandomA2B(a, b);
  }

  Point getRandomPosition() {
    return this.context?.getRandomPosition();
  }

  static void fullScreen() {
    return Util.fullScreen();
  }

  ////////////////////////////////////////////////////////////
  ///
  /// App Basic function
  ///
  ////////////////////////////////////////////////////////////
  init() {
    print('Zerker:: $this Inited');
  }

  update(int time) {
    this.stage.update(time);
  }

  resize(Size size) {}

  render(Canvas canvas) {
    this.stage.render(canvas);
  }

  customDraw(Canvas canvas) {}

  ////////////////////////////////////////////////////////////
  ///
  /// Touch interaction related event method
  ///
  ////////////////////////////////////////////////////////////
  tapDown(ZKEvent event) {
    this.stage.tapDown(event);
    this.onTapDown(event);
  }

  tapUp(ZKEvent event) {
    this.stage.tapUp(event);
    this.onTapUp(event);
  }

  onTapDown(ZKEvent event) {}
  onTapUp(ZKEvent event) {}

  dispose() {
    this.destroyed = true;
    this.stage.dispose();
    this.stage = null;
    if (this.onDispose != null) onDispose();
  }

  String toString() {
    return '[ type:$type id:$id stage:$stage ]';
  }
}
