import 'dart:ui';
import "dart:math";
import './node.dart';
import "../core/context.dart";

class ZKContainer extends ZKNode {
  List<ZKNode> children = [];

  @override
  String type = "ZKContainer";

  ZKContainer() : super();

  @override
  set alpha(double a) {
    if (a < 0) return;
    super.alpha = a;

    for (int i = 0; i < this.children.length; i++) {
      ZKNode child = this.children[i];
      child.alpha = child.alpha;
    }
  }

  @override
  set context(ZKContext? c) {
    super.context = c;
    for (int i = 0; i < this.children.length; i++) {
      ZKNode child = this.children[i];
      child.context = c;
    }
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Parent container related APIs method
  ///
  ////////////////////////////////////////////////////////////
  ZKNode getChild(int index) {
    return this.children[index];
  }

  void addChild(ZKNode child) {
    this.addChildAt(child, this.children.length);
  }

  void removeChild(ZKNode child) {
    int index = this.children.indexOf(child);
    if (index >= 0) {
      child.parent = null;
      child.worldAlpha = child.alpha;
      this.children.remove(child);
    }
  }

  void removeAllChild() {
    for (int i = this.children.length - 1; i >= 0; i--) {
      this.removeChild(this.children[i]);
    }
  }

  void addChildAt(ZKNode child, int index) {
    index = min(index, children.length);
    index = max(index, 0);

    if (child.parent != null) (child.parent as ZKContainer).removeChild(child);
    child.parent = this;
    this.children.insert(index, child);
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Update, render and other related functions
  ///
  ////////////////////////////////////////////////////////////
  @override
  void update(int time) {
    if (this.visible == false) return;
    super.update(time);
    this.updateChild(time);
  }

  @override
  void render(Canvas canvas) {
    if (this.visible == false || this.alpha == 0) return;

    this.renderChild(canvas);
    this.draw(canvas);
  }

  void updateChild(int time) {
    for (var i = 0; i < this.children.length; i++) {
      var child = this.children[i];
      child.update(time);
    }
  }

  void renderChild(Canvas canvas) {
    for (int i = 0; i < this.children.length; i++) {
      var child = this.children[i];
      child.render(canvas);
    }
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Interaction-related functions
  ///
  ////////////////////////////////////////////////////////////
  @override
  ZKNode? hitTest(touchX, touchY) {
    if (this.canInteractive == false) return null;

    for (int i = this.children.length - 1; i >= 0; i--) {
      ZKNode child = this.children[i];
      ZKNode? result = child.hitTest(touchX, touchY);
      if (result != null) return result;
    }
    return null;
  }

  void forEach(Function(ZKNode child) func) {
    for (int i = 0; i < this.children.length; i++) {
      ZKNode child = this.children[i];
      func(child);
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < this.children.length; i++) {
      ZKNode child = this.children[i];
      child.dispose();
    }

    super.dispose();
  }

  @override
  String toString() {
    return '[ type:$type id:$id children:${this.children.length.toString()} ]';
  }
}
