import 'package:flutter/widgets.dart';
import '../event/event.dart';
import "../utils/util.dart";
import '../app.dart';
import './renderbox.dart';

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
    ZerkerRenderObjectWidget zerkerWidget =
        ZerkerRenderObjectWidget(app: app, clip: clip);
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
