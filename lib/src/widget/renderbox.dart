import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import "../utils/util.dart";
import '../app.dart';

class ZerkerRenderObjectWidget extends LeafRenderObjectWidget {
  final ZKApp? app;
  final bool? clip;

  ZerkerRenderObjectWidget({this.app, this.clip});

  @override
  RenderBox createRenderObject(BuildContext context) {
    _ZerkerBox zerkerBox = _ZerkerBox(app: app!, clip: clip ?? false);
    return RenderProxyBox(zerkerBox);
  }
  
  @override
  void updateRenderObject(BuildContext context, RenderProxyBox renderProxyBox) {
    renderProxyBox.child = _ZerkerBox(app: app!, clip: clip ?? false);
  }
}

class _ZerkerBox extends RenderBox
    with RenderObjectWithChildMixin<RenderBox>, WidgetsBindingObserver {
  String id = Util.uuid();
  ZKApp? app;
  bool? clip;
  Canvas? _canvas;
  Ticker? _ticker;
  int _oldTime = 0;
  int _elapsed = 0;
  bool _inited = false;
  bool _mounted = false;

  _ZerkerBox({required ZKApp app, bool clip = false}) {
    this.app = app;
    this.clip = clip;
    _addTicker();
  }

  void _init() {
    if (!_inited) {
      app?.init();
      _inited = true;
    }
  }

  void _mount() {
    if (!_mounted) {
      app?.mounted();
      _mounted = true;
    }
  }

  void _addTicker() {
    _ticker = Ticker((Duration duration) {
      if (app!.destroyed) return;

      _init();
      int time = duration.inMilliseconds - _oldTime;

      // Fix the time difference caused by switching between front and back of the app
      if (ZKApp.enableFixLongInterval &&
          time > (ZKApp.longIntervalTime * 1000).toInt()) {
        _oldTime = duration.inMilliseconds;
        time = 0;
      }

      if (app!.fps == 60) {
        updateAndPaint(time);
      } else {
        this._elapsed += time;
        if (this._elapsed >= app!.delay) {
          this._elapsed = 0;
          updateAndPaint(time);
        }
      }
      _oldTime = duration.inMilliseconds;
    });
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    WidgetsBinding.instance.addObserver(this);

    if (app!.destroyed != true) {
      try {
        _ticker?.start();
      } catch (e) {}
    }
  }

  @override
  void detach() {
    super.detach();
    WidgetsBinding.instance.removeObserver(this);

    if (app!.destroyed != true) {
      try {
        app!.dispose();
        _ticker?.stop();
        _ticker?.dispose();
      } catch (e) {}
    }
  }

  void updateAndPaint(int time) {
    app!.update(time);
    markNeedsPaint();
  }

  @override
  void performResize() {
    super.performResize();
    size = constraints.biggest;
    if (app != null && !app!.destroyed) {
      app!.context!.size = size;
      app!.resize(size);
    }
    _mount();
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.biggest;

  @override
  bool get sizedByParent => true;

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (app!.destroyed) return;

    app!.context!.offset = offset;
    if (clip == true) {
      context.pushClipRect(
          needsCompositing, offset, Offset.zero & size, paintStack);
    } else {
      paintStack(context, offset);
    }
  }

  @protected
  void paintStack(PaintingContext context, Offset? offset) {
    _canvas = context.canvas;
    _resetCanvas(_canvas!);
    if (offset != null) _canvas!.translate(offset.dx, offset.dy);

    _canvas?.save();
    app!.render(_canvas!);
    app!.customDraw(_canvas!);
    _canvas?.restore();
  }

  void _resetCanvas(Canvas canvas) {}
}
