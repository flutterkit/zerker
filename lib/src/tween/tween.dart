import './miticker.dart';
import './ease.dart';

import '../node/node.dart';
import '../math/point.dart';

List<ZKTween> _tweens = [];

class ZKTween {
  ///////////////////////////////////////////////////////////////////////////
  ///
  /// ZKTween static methods
  ///
  ///////////////////////////////////////////////////////////////////////////
  static List<ZKTween> getAll() {
    return _tweens;
  }

  static void removeAll() {
    _tweens = [];
  }

  static void add(ZKTween tween) {
    _tweens.add(tween);
  }

  static void remove(ZKTween tween) {
    var i = _tweens.indexOf(tween);

    if (i != -1) {
      _tweens.removeAt(i);
    }
  }

  static void setup() {
    Miticker.init(ZKTween._tickerHandler);
    Miticker.start();
  }

  static void close() {
    Miticker.stop();
  }

  static bool update([time]) {
    if (_tweens.length == 0) return false;

    int i = 0, l = _tweens.length;
    time = time != null ? time : new DateTime.now().millisecondsSinceEpoch;

    while (i < l) {
      if (_tweens[i]._update(time)) {
        i++;
      } else {
        _tweens.removeAt(i);
        l--;
      }
    }

    return true;
  }

  static void _tickerHandler(Duration duration) {
    ZKTween.update();
  }

  ///////////////////////////////////////////////////////////////////////////
  ///
  /// ZKTween class
  ///
  ///////////////////////////////////////////////////////////////////////////
  dynamic _target;
  Map<String, dynamic> _object = {};
  Map<String, dynamic> _valuesStart = {};
  Map<String, dynamic> _valuesEnd = {};

  int _duration = 0;
  int _delayTime = 0;
  int _startTime = 0;

  bool _autoRemove = false;
  ZKTween? _chainedTween;

  Function _easingFunction = Ease.linear.none;
  Function(dynamic obj)? _onUpdateCallback;
  Function(dynamic obj)? _onCompleteCallback;

  ZKTween(dynamic target) {
    if (target is Point) {
      _target = target;
    } else if (target is ZKNode) {
      _target = target;
    } else {
      throw new Exception('Zerker:: Input type must be Point or ZKNode!');
    }

    _valuesStart = {};
    _valuesEnd = {};

    _duration = 1000;
    _delayTime = 0;
    _easingFunction = Ease.linear.none;
  }

  ZKTween to(Map<String, dynamic> properties, [int duration = 1000]) {
    _duration = duration;
    _valuesEnd = properties;
    return this;
  }

  ZKTween start([time]) {
    ZKTween.setup();
    ZKTween.add(this);

    _startTime =
        time != null ? time : new DateTime.now().millisecondsSinceEpoch;
    _startTime += _delayTime;

    if (_target is Point) {
      _object = _target.toMap();
    } else if (_target is ZKNode) {
      _object = _target.toMap();
    }

    for (var property in _valuesEnd.keys) {
      if (_object[property] == null) continue;
      _valuesStart[property] = _object[property];
    }

    return this;
  }

  ZKTween stop() {
    ZKTween.remove(this);
    return this;
  }

  ZKTween delay(int amount) {
    _delayTime = amount;
    return this;
  }

  ZKTween easing(easing) {
    _easingFunction = easing;
    return this;
  }

  ZKTween chain(ZKTween chainedTween) {
    _chainedTween = chainedTween;
    return this;
  }

  ZKTween onUpdate(Function(dynamic obj)? onUpdateCallback) {
    if (onUpdateCallback == null) return this;
    _onUpdateCallback = onUpdateCallback;
    return this;
  }

  ZKTween onComplete(Function(dynamic obj)? onCompleteCallback) {
    if (onCompleteCallback == null) return this;
    _onCompleteCallback = onCompleteCallback;
    return this;
  }

  ZKTween autoRemove() {
    _autoRemove = true;
    return this;
  }

  bool _update(int time) {
    if (time < _startTime) {
      return true;
    }

    var elapsed = (time - _startTime) / _duration;
    elapsed = elapsed > 1 ? 1 : elapsed;

    var value = _easingFunction(elapsed);
    for (var property in _valuesStart.keys) {
      var start = _valuesStart[property];
      var end = _valuesEnd[property];

      _object[property] = start + (end - start) * value;
    }

    _updateNode();
    if (elapsed == 1) {
      _completeNode();
      return false;
    }

    return true;
  }

  void _updateNode() {
    if (_target is Point) {
      _target.x = _object["x"] ?? _target.x;
      _target.y = _object["y"] ?? _target.y;
    } else if (_target is ZKNode) {
      _target.position.x = _object["x"] ?? _target.position.x;
      _target.position.y = _object["y"] ?? _target.position.y;
      _target.rotation = _object["rotation"] ?? _target.rotation;
      _target.scale.x = _object["scaleX"] ?? _target.scale.x;
      _target.scale.y = _object["scaleY"] ?? _target.scale.y;
      _target.alpha = _object["alpha"] ?? _target.alpha;
    }

    if (_onUpdateCallback != null) {
      _onUpdateCallback!(_object);
    }
  }

  void _completeNode() {
    if (_onCompleteCallback != null) {
      _onCompleteCallback!(_object);
    }

    if (_autoRemove && _target is ZKNode) {
      (_target as ZKNode).remove();
    }

    if (_chainedTween != null) {
      _chainedTween!.start();
    } else {
      // _target = null;
    }
  }
}
