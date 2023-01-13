import './node.dart';
import './container.dart';
import '../event/event.dart';
import 'package:flutter/material.dart';

class ZKStage extends ZKContainer {
  @override
  String type = "ZKStage";

  @override
  void update(int time) {
    this.updateChild(time);
  }

  @override
  void render(Canvas canvas) {
    this.draw(canvas);
    this.renderChild(canvas);
  }

  @override
  void draw(Canvas canvas, [Size? size]) {
    if (this.color != null) canvas.drawRect(this.context!.rect!, this.paint);
  }

  void tapDown(ZKEvent event) {
    for (int i = this.children.length - 1; i >= 0; i--) {
      ZKNode child = this.children[i];
      ZKNode? result = child.hitTest(event.dx, event.dy);

      if (result != null) {
        event.target = result;
        if (result.onTapDown != null) result.onTapDown!(event);
        break;
      }
    }

    if (this.onTapDown != null) this.onTapDown!(event);
  }

  void tapUp(ZKEvent event) {
    for (int i = this.children.length - 1; i >= 0; i--) {
      ZKNode child = this.children[i];
      ZKNode? result = child.hitTest(event.dx, event.dy);

      if (result != null) {
        event.target = result;
        if (result.onTapUp != null) result.onTapUp!(event);
        break;
      }
    }

    if (this.onTapUp != null) this.onTapUp!(event);
  }
}
