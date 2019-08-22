import 'dart:ui';
import 'dart:async';
import './image.dart';
import '../math/mathutil.dart';
import '../texture/assets.dart';
import '../texture/basetexture.dart';
import '../animate/frame.dart';
import '../animate/animator.dart';

class ZKSprite extends ZKImage {
  @override
  String type = "ZKSprite";

  /// Animator
  Animator animator;
  Timer _timer;

  ZKSprite({String image, String key, String type, String json, double width = 100, double height = 100}) : super() {
    this.animator = new Animator();
    if (key != null) {
      this.texture = ZKAssets.getAsset(key);
      this.textureType = ZKAssets.getType(texture);
      if (this.texture == null) throw ("Zerker:: Sorry, this Key '$key' does not get any assets!");

      _timer = new Timer(Duration(milliseconds: 0), () {
        this._loadComplete(this.texture);
        _timer.cancel();
      });
    } else if (type != null) {
      this.loadSpriteSheet(image, Size(width, height));
      this.textureType = type;
    } else if (json != null) {
      this.loadAtlas(json, image);
      this.textureType = "atlas";
    } else {
      this.loadImage(image);
      this.textureType = "image";
    }
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Load Assets Function
  ///
  ////////////////////////////////////////////////////////////
  void loadSpriteSheet(String image, Size size) async {
    try {
      this.texture = await ZKAssets.loadSpriteSheet(image: image, size: size);
      this._loadComplete(texture);
    } catch (err) {
      this._loadError(err);
    }
  }

  void loadAtlas(String json, String image) async {
    try {
      this.texture = await ZKAssets.loadAltas(json: json, image: image);
      this._loadComplete(texture);
    } catch (err) {
      this._loadError(err);
    }
  }

  void loadImage(String url) async {
    try {
      this.texture = await ZKAssets.loadImage(path: url);
      this._loadComplete(texture);
    } catch (err) {
      this._loadError(err);
    }
  }

  void _loadComplete(BaseTexture texture) {
    this.animator.framesLength = this.texture.list.length;
    if (this.onLoad != null) this.onLoad(texture.image);
  }

  void _loadError(err) {
    print("Zerker:: $err");
    if (this.onError != null) this.onError(err);
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Operation frame
  ///
  ////////////////////////////////////////////////////////////
  Frame get frame {
    if (this.texture == null) return null;

    var key = this.animator.getCurrentFrameKey();
    return this.texture.getFrame(key);
  }

  @override
  void update(int time) {
    if (this.visible == false) return;
    this.animator.update(time);

    var angle = rotation;
    if (this.frame != null && this.frame.rotated) {
      angle -= 90;
      frame.rotateDstRectOnce(anchor.x, anchor.y);
    }

    this.updateTransform(position.x, position.y, scale.x, scale.y, angle, skew.x, skew.y, regX, regY);
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Play and Stop
  ///
  ////////////////////////////////////////////////////////////
  void play(String name, [int rate, bool loop = false]) {
    this.animator.play(name, rate, loop);
  }

  void stop([String name]) {
    this.animator.stop(name);
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Sprite Drawing Function
  ///
  ////////////////////////////////////////////////////////////
  @override
  void draw(Canvas canvas, [Size size]) {
    if (this.texture == null) return;
    if (!this.frame.isEnabled) return;

    canvas.drawImageRect(this.frame.image, this.frame.srcRect, this.frame.dstRect, this.paint);
    if (this.debug) {
      canvas.drawCircle(this.center, 5.0, this.paint);
      canvas.drawRect(this.frame.dstRect, strokePaint);
    }
  }

  @override
  ZKSprite hitTest(touchX, touchY) {
    if (frame == null) return null;

    var a00 = matrix.a,
        a01 = matrix.c,
        a02 = matrix.tx,
        a10 = matrix.b,
        a11 = matrix.d,
        a12 = matrix.ty,
        id = 1 / (a00 * a11 + a01 * -a10);

    var x = a11 * id * touchX + -a01 * id * touchY + (a12 * a01 - a02 * a11) * id;
    var y = a00 * id * touchY + -a10 * id * touchX + (-a12 * a00 + a02 * a10) * id;

    if (MathUtil.inA2B(x, frame.dstRect.left, frame.dstRect.right) &&
        MathUtil.inA2B(y, frame.dstRect.top, frame.dstRect.bottom)) {
      return this;
    }

    return null;
  }

  @override
  void dispose() {
    super.dispose();

    this.animator.dispose();
  }
}
