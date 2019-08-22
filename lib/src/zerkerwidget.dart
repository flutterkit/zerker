import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';

import './event/event.dart';
import "./utils/util.dart";
import './app.dart';

class Zerker extends StatelessWidget {
  final ZKApp app;
  final String id = Util.uuid();

  Zerker({Key key, @required this.app}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (app.interactive) {
      return GestureDetector(
        onTapDown: (TapDownDetails details) {
          app.tapDown(ZKEvent.fromDetails(details));
        },
        onTapUp: (TapUpDetails details) {
          app.tapUp(ZKEvent.fromDetails(details));
        },
        child: _ZerkerRenderObjectWidget(app: app),
      );
    } else {
      return _ZerkerRenderObjectWidget(app: app);
    }
  }
}

class _ZerkerRenderObjectWidget extends LeafRenderObjectWidget {
  final ZKApp app;
  _ZerkerRenderObjectWidget({this.app});

  @override
  RenderBox createRenderObject(BuildContext context) {
    _ZerkerBox zerkerBox = _ZerkerBox(context, app);
    return RenderProxyBox(zerkerBox);
  }

  @override
  void updateRenderObject(BuildContext context, RenderProxyBox renderProxyBox) {
    renderProxyBox.child = _ZerkerBox(context, app);
  }
}

class _ZerkerBox extends RenderBox with RenderObjectWithChildMixin<RenderBox>, WidgetsBindingObserver {
  BuildContext context;
  String id = Util.uuid();
  ZKApp app;

  bool _inited = false;
  Ticker _ticker;
  Canvas _canvas;
  int _oldTime = 0;

  _ZerkerBox(BuildContext context, ZKApp app) {
    this.app = app;
    this.context = context;
    _addTicker();
  }

  void _init() {
    if (!_inited) {
      app.init();
      _inited = true;
    }
  }

  void _addTicker() {
    _ticker = new Ticker((Duration duration) {
      if (app.destroyed) return;

      _init();
      update(duration.inMilliseconds - _oldTime);
      markNeedsPaint();
      _oldTime = duration.inMilliseconds;
    });
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _ticker.start();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void detach() {
    super.detach();
    this.dispose();
  }

  void dispose() {
    print('Zerker:: ZKApp $app Dispose');
    _ticker.stop();
    WidgetsBinding.instance.removeObserver(this);
    app.dispose();
  }

  void update(int time) {
    app.update(time);
  }

  @override
  void performLayout() {
    //performResize();
  }

  @override
  void performResize() {
    size = constraints.biggest;
    if (app != null && !app.destroyed) {
      app.context.size = size;
      app.resize(size);
    }
  }

  @override
  bool get sizedByParent => true;

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (app.destroyed) return;

    app.context.offset = offset;
    if (app.clip == true) {
      context.pushClipRect(needsCompositing, offset, Offset.zero & size, paintStack);
    } else {
      paintStack(context, offset);
    }
  }

  @protected
  void paintStack(PaintingContext context, Offset offset) {
    _canvas = context.canvas;
    _resetCanvas(_canvas);
    if (offset != null) _canvas.translate(offset.dx, offset.dy);

    _canvas.save();
    app.render(_canvas);
    app.customDraw(_canvas);
    _canvas.restore();
  }

  void _resetCanvas(Canvas canvas) {}
}
