import 'dart:ui';
import 'dart:async';
import './node.dart';
import '../animate/frame.dart';
import '../texture/assets.dart';
import '../texture/imgtexture.dart';
import '../texture/basetexture.dart';

class ZKImage extends ZKNode {
  @override
  String type = "ZKImage";
  Function onLoad;
  Function onError;

  /// Texture
  BaseTexture texture;
  String textureType;
  Paint strokePaint = Paint()..style = PaintingStyle.stroke;

  Timer _timer;
  Rect _clip;

  ////////////////////////////////////////////////////////////
  ///
  /// Setter and Getter methods
  ///
  ////////////////////////////////////////////////////////////
  @override
  double get oriWidth {
    return frame != null ? frame.width : 0;
  }

  @override
  double get oriHeight {
    return frame != null ? frame.height : 0;
  }

  Image get image {
    return texture != null ? texture.image : null;
  }

  set url(String url) {
    this.load(url);
  }

  set image(Image img) {
    this.texture = ImgTexture(img);
  }

  set clip(Rect c) {
    this._clip = c;
    if (this.texture != null) this.texture.setAllRectByClip(c);
  }

  get clip {
    return this._clip;
  }

  ////////////////////////////////////////////////////////////
  ///
  /// ZKImage constructor
  ///
  ////////////////////////////////////////////////////////////
  ZKImage([String url]) : super() {
    if (url != null) this.lazyLoad(url);
    this.textureType = "image";
  }

  void lazyLoad(String url, [int delay = 0]) {
    _timer = new Timer(Duration(milliseconds: delay), () {
      this.load(url);
      _timer.cancel();
    });
  }

  void load(String url) async {
    try {
      this.texture = await ZKAssets.loadImage(path: url);
      if (onLoad != null) onLoad(url);
    } catch (e) {
      if (onError != null) onError(e);
    }
  }

  Frame get frame {
    if (this.texture == null) return null;
    return this.texture.getFrame(0);
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Native drawing Image function
  ///
  ////////////////////////////////////////////////////////////
  @override
  void draw(Canvas canvas, [Size size]) {
    if (this.frame == null) return;
    canvas.drawImageRect(this.frame.image, this.frame.srcRect, this.frame.dstRect, this.paint);

    if (this.debug) {
      canvas.drawCircle(this.center, 5.0, this.paint);
      canvas.drawRect(Rect.fromLTWH(0, 0, oriWidth, oriHeight), strokePaint);
    }
  }

  @override
  void dispose() {
    super.dispose();

    try {
      if (this.clip != null) this.clip = null;
      //if (this.frame != null) this.frame.dispose();
      _timer.cancel();
    } catch (e) {}
  }
}
