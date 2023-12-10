import './animation.dart';
import '../utils/listmap.dart';
import '../core/constant.dart';

////////////////////////////////////////////////////////////
///
/// Animator Class
/// sprite.animator.add(name, frames);
/// sprite.animator.play(name, rate, loop);
/// sprite.animator.stop(name);
///
////////////////////////////////////////////////////////////
class Animator {
  Function? onComplete;
  String status = "stop";

  ListMap _aniList = ListMap();
  Animation? _currentAni;
  int _framesLength = -1;

  bool get isEnabled {
    return _aniList.isEmpty != true;
  }

  set framesLength(int length) {
    this._framesLength = length;
    _aniList.forEach((Animation ani, _) => ani.framesLength = framesLength);
  }

  int get framesLength {
    return this._framesLength;
  }

  dynamic getCurrentFrameKey() {
    return _currentAni != null ? _currentAni?.getCurrentFrameKey() : 0;
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Play and Stop
  ///
  ////////////////////////////////////////////////////////////
  void play(String name, [int? rate, bool loop = false]) {
    Animation? ani = _aniList.getItem(name);
    if (ani == null) {
      throw ("Zerker:: Sorry, there is no corresponding animation information.");
    } else {
      ani.rate = rate ?? ani.rate;
      ani.loop = loop;
      _currentAni = ani;
      _currentAni?.reset();
      this.status = "play";
    }
  }

  void stop([String? name]) {
    if (name != null) {
      this.play(name, 9999);
    }

    this.status = "stop";
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Making frames
  ///
  ////////////////////////////////////////////////////////////
  void make(String name,
      [List? frames, int rate = Constant.RATE, bool loop = false]) {
    Animation ani = Animation(name, frames, rate, loop);
    ani.framesLength = framesLength;
    ani.onComplete = onComplete;

    _aniList.add(name, ani);
  }

  void add(
      {String name = "",
      List? frames,
      int rate = Constant.RATE,
      bool loop = false}) {
    return make(name, frames, rate, loop);
  }

  void remove(String name, [bool destroy = false]) {
    Animation? ani = _aniList.getItem(name);
    if (ani != null && destroy) {
      ani.dispose();
    }

    _aniList.remove(name);
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Update func
  ///
  ////////////////////////////////////////////////////////////
  void update(int time) {
    if (this.status == "stop") return;

    _currentAni?.update(time);
  }

  ////////////////////////////////////////////////////////////
  ///
  /// clear and dispose
  ///
  ////////////////////////////////////////////////////////////
  void clear() {
    _aniList.clear((ani) => ani.dispose());
  }

  dispose() {
    this.clear();
    onComplete = null;
  }
}
