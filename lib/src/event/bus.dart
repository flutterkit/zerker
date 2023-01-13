////////////////////////////////////////////////////////////
///
/// ZKBus - A simple event bus class, reference from vue events,
/// thanks to the original author.
///
////////////////////////////////////////////////////////////
class ZKBus {
  static Map<String, List<Function>> _events = {};

  static void emit(String eventName, [dynamic args]) {
    List<Function>? cbs = ZKBus._events[eventName];

    if (cbs != null) {
      for (var i = 0, l = cbs.length; i < l; i++) {
        Function callback = cbs[i];

        if (args == null)
          callback();
        else
          callback(args);
      }
    }
  }

  static void on(String eventName, Function callback) {
    if (ZKBus._events[eventName] == null) {
      ZKBus._events[eventName] = [];
    }

    ZKBus._events[eventName]?.add(callback);
  }

  static void off(String eventName, [Function? callback]) {
    var cbs = ZKBus._events[eventName];
    if (cbs == null) {
      return;
    }

    if (callback == null) {
      ZKBus._events.remove(eventName);
      return;
    }

    Function cb;
    int i = cbs.length;
    while (i-- > 0) {
      cb = cbs[i];
      if (cb == callback) {
        cbs.removeAt(i);
        break;
      }
    }
  }

  static void once(String eventName, Function callback) {
    Function? handler;
    handler = ([args]) {
      ZKBus.off(eventName, handler);
      if (args == null)
        callback();
      else
        callback(args);
    };

    ZKBus.on(eventName, handler);
  }
}
