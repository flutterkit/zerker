import "dart:ui";
import "./basetexture.dart";
import "../animate/frame.dart";

class ImgTexture extends BaseTexture {
  String type = "imgtexture";

  ImgTexture(Image image) {
    this.image = image;
    this.generateFrames();
  }

  Frame getFrame(dynamic index) {
    return list[0];
  }

  int get length {
    return 1;
  }

  Size get size {
    return Size(image.width.toDouble(), image.height.toDouble());
  }

  void generateFrames() {
    var w = image.width.toDouble();
    var h = image.height.toDouble();

    Frame frame = new Frame(this.type);
    frame.image = image;
    frame.setSrcRect(0, 0, w, h);
    frame.setDstRect(0, 0, w, h);

    list.add(frame);
  }
}
