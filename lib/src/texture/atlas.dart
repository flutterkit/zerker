import "dart:ui";
import "./basetexture.dart";
import "../utils/util.dart";
import "../animate/frame.dart";

class Atlas extends BaseTexture {
  Map<String, dynamic>? data;
  String imageUrl = "";
  String type = "atlas";

  Atlas(Map<String, dynamic>? json, [Image? image]) {
    this.data = json ?? {};
    this.imageUrl = getFromMeta("image");
    this.image = image;
    this.generateFrames();
  }

  Map<String, dynamic>? get meta {
    return this.data?["meta"];
  }

  dynamic get frames {
    return this.data?["frames"] ?? [];
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Atlas Meta Information
  ///
  ////////////////////////////////////////////////////////////
  String get version {
    return getFromMeta("version");
  }

  double get scale {
    return getFromMeta("scale", 1);
  }

  Size? get size {
    var size = getFromMeta("size");
    return size == null ? null : Size(size["w"], size["h"]);
  }

  dynamic getFromMeta(String key, [dynamic defaultVal]) {
    return meta != null ? meta![key] : (defaultVal ?? null);
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Atlas Frames Information
  ///
  ////////////////////////////////////////////////////////////
  int get length {
    return frames.length;
  }

  String get format {
    return frames is List ? "array" : "json";
  }

  Frame? getFrame(dynamic key) {
    if (key is int) {
      return Util.getListVal(list, key);
    } else {
      for (int i = 0; i < list.length; i++) {
        Frame frame = list[i];
        if (key == frame.name) {
          return frame;
        }
      }
    }

    return null;
  }

  void generateFrames() {
    Util.forEach(frames, (Map<String, dynamic> obj, key) {
      var l = Util.getByPath(obj, "frame.x");
      var t = Util.getByPath(obj, "frame.y");
      var w = Util.getByPath(obj, "frame.w");
      var h = Util.getByPath(obj, "frame.h");
      var px = Util.getByPath(obj, "pivot.x");
      var py = Util.getByPath(obj, "pivot.y");

      Frame frame = new Frame(this.type);
      frame.image = image!;
      frame.name = Util.getByPath(obj, "filename");
      frame.rotated = Util.getByPath(obj, "rotated");
      frame.trimmed = Util.getByPath(obj, "trimmed");

      frame.setAnchor(px, py);
      frame.setSrcRect(l, t, w, h);
      frame.setDstRect(0, 0, w, h);

      list.add(frame);
    });
  }
}
