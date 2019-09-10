import '../core/constant.dart';
import '../utils/util.dart';

List defaultList = Util.convertConsecutiveList(['0-42']);

class Animation {
  Function onComplete;

  String name;
  String framesType;
  bool loop = false;

  int index = 0;
  int elapsed = 0;
  double delay = 0;

  List _frames;

  ////////////////////////////////////////////////////////////
  ///
  /// Setter and Getter methods
  ///
  ////////////////////////////////////////////////////////////
  int get rate {
    return _rate;
  }

  set rate(int r) {
    delay = 1000.0 / r;
    _rate = r;
  }

  set framesLength(int length) {
    if (length > 0 && this.framesType == "all") {
      this.frames = this.frames.sublist(0, length);
    }
  }

  List get frames {
    return this._frames;
  }

  set frames(List f) {
    this._frames = f;
    this.framesType = "auto";
  }

  int _rate = Constant.RATE;

  Animation(String name,
      [List frames, int rate = Constant.RATE, bool loop = false]) {
    this.name = name;
    this.rate = rate ?? Constant.RATE;
    this.loop = loop;

    if (frames == null) {
      this.frames = defaultList;
      this.framesType = "all";
    } else {
      this.frames = Util.convertConsecutiveList(frames);
      this.framesType = "auto";
    }
  }

  dynamic getCurrentFrameKey() {
    if (this.frames == null) return 0;
    return this.frames[this.index];
  }

  void update(int seconds) {
    if (this.frames == null) return;

    this.elapsed += seconds;
    if (this.elapsed >= this.delay) {
      this.elapsed = 0;
      this.index++;

      if (this.index >= this.frames.length) {
        if (this.loop == true) {
          this.index = 0;
        } else {
          this.index = this.frames.length - 1;
        }
      }

      if (this.loop != true && onComplete != null) {
        onComplete();
      }
    }
  }

  void reset() {
    this.elapsed = 0;
    this.index = 0;
  }

  void dispose() {
    this.name = null;
    this.onComplete = null;
    this.elapsed = 0;
    this.index = 0;

    if (this.frames != null) {
      this.frames.clear();
      this.frames = null;
    }
  }
}
