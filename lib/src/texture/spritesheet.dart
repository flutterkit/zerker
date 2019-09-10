import "dart:ui";
import "./basetexture.dart";
import "../animate/frame.dart";

class SpriteSheet extends BaseTexture {
  String type = "spritesheet";
  Size frameSize;

  int row;
  int col;

  SpriteSheet(Image image, Size frameSize) {
    this.image = image;
    this.frameSize = frameSize;

    this.row = (image.width / frameSize.width).floor();
    this.col = (image.height / frameSize.height).floor();

    this.generateFrames();
  }

  Frame getFrame(dynamic index) {
    return list[index];
  }

  int get length {
    return row * col;
  }

  Size get size {
    return Size(image.width.toDouble(), image.height.toDouble());
  }

  ////////////////////////////////////////////////////////////
  ///   a1 a2 a3 a4 a5
  ///   b1 b2 b3 b4 b5
  ///   c1 ...
  ////////////////////////////////////////////////////////////
  void generateFrames() {
    var w = frameSize.width;
    var h = frameSize.height;

    for (int i = 0; i < this.col; i++) {
      for (int j = 0; j < this.row; j++) {
        Frame frame = new Frame(this.type);
        frame.image = image;

        frame.setSrcRect(j * w, i * h, w, h);
        frame.setDstRect(0, 0, w, h);
        list.add(frame);
      }
    }
  }
}
