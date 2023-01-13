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

  ZKStage stage = ZKStage();
  bool debug = false;
  bool destroyed = false;
  Function? onDispose;
  double delay = 1000 / 60;
  int _fps = 60;

  ZKApp() {
    this.stage.context = new ZKContext();
  }

  ZKContext? get context {
    return this.stage.context;
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

  set fps(int f) {
    this.delay = 1000 / f;
    this._fps = f;
  }

  int get fps {
    return this._fps;
  }

  Size get size {
    return this.context!.size;
  }

  double get appWidth {
    return this.context!.appWidth;
  }

  double get appHeight {
    return this.context!.appHeight;
  }

  Color getRandomColor() {
    return this.context!.getRandomColor();
  }

  double getRandomA2B(double a, double b) {
    return this.context!.getRandomA2B(a, b);
  }

  Point getRandomPosition() {
    return this.context!.getRandomPosition();
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
    if (debug == true) print('Zerker:: Inited $this');
  }

  mounted() {}

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
  }

  tapUp(ZKEvent event) {
    this.stage.tapUp(event);
  }

  dispose() {
    if (debug == true) print('Zerker:: Dispose $this');

    this.destroyed = true;
    this.stage.dispose();
    if (this.onDispose != null) onDispose!();
  }

  String toString() {
    return '[ type:$type id:$id stage:$stage ]';
  }
}
