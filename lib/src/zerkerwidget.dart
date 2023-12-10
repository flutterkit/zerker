import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import './event/event.dart';
import "./utils/util.dart";
import './app.dart';

class Zerker extends StatelessWidget {
  final String id = Util.uuid();
  final ZKApp app;
  final bool? interactive;
  final bool? enablePan;
  final bool? clip;
  final double? width;
  final double? height;

  Zerker({
    required this.app,
    Key? key,
    this.interactive,
    this.enablePan,
    this.clip,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _ZerkerRenderObjectWidget zerkerWidget =
        _ZerkerRenderObjectWidget(app: app, clip: clip);
    RenderObjectWidget child;
    if (width != null || height != null) {
      child = ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: width, height: height),
          child: zerkerWidget);
    } else {
      child = zerkerWidget;
    }

    if (interactive == true) {
      if (enablePan == true) {
        return GestureDetector(
          onTapDown: (TapDownDetails details) {
            app.tapDown(ZKEvent.fromDetails(details));
          },
          onTapUp: (TapUpDetails details) {
            app.tapUp(ZKEvent.fromDetails(details));
          },

          /// pan events
          onPanDown: (DragDownDetails details) {
            app.tapDown(ZKEvent.fromDetails(details));
          },
          onPanStart: (DragStartDetails details) {
            app.panStart(ZKEvent.fromDetails(details));
          },
          onPanUpdate: (DragUpdateDetails details) {
            app.panUpdate(ZKEvent.fromDetails(details));
          },
          onPanEnd: (DragEndDetails details) {
            app.panEnd(ZKEvent.fromDetails(details));
          },
          onPanCancel: () {
            //app.panEnd(ZKEvent.fromDetails(DragEndDetails()));
          },
          child: child,
        );
      } else {
        return GestureDetector(
          onTapDown: (TapDownDetails details) {
            app.tapDown(ZKEvent.fromDetails(details));
          },
          onTapUp: (TapUpDetails details) {
            app.tapUp(ZKEvent.fromDetails(details));
          },
          child: child,
        );
      }
    } else {
      return child;
    }
  }
}

class _ZerkerRenderObjectWidget extends LeafRenderObjectWidget {
  final ZKApp? app;
  final bool? clip;

  _ZerkerRenderObjectWidget({this.app, this.clip});

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
