import 'package:flutter/scheduler.dart';

Ticker? _ticker;

class Miticker {
  static Ticker? init(Function func) {
    if (_ticker == null) {
      _ticker = new Ticker((Duration duration) {
        func(duration);
      });
    }

    return _ticker;
  }

  static start() {
    if (_ticker?.isActive != true) {
      _ticker?.start();
    }
  }

  static stop() {
    if (_ticker!.isActive) {
      _ticker?.stop();
    }
  }

  static Ticker? get ticker {
    return _ticker;
  }
}
