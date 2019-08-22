import 'dart:collection';

////////////////////////////////////////////////////////////
///
/// ListMap
/// {"key1":[]}
///
////////////////////////////////////////////////////////////
class ListMap {
  LinkedHashMap<String, dynamic> _map;

  ListMap() {
    this._map = new LinkedHashMap();
  }

  void add(String id, dynamic item) {
    this._map[id] = item;
  }

  void remove(String id) {
    this._map.remove(id);
  }

  dynamic getItem(String id) {
    return this._map[id];
  }

  ListMap forEach(Function func) {
    for (var id in this._map.keys) {
      var item = this._map[id];
      func(item, id);
    }

    return this;
  }

  ListMap clear([Function clearFunc]) {
    for (var id in this._map.keys) {
      var item = this._map[id];
      if (clearFunc != null) clearFunc(item);

      if (item is Map || item is List) {
        item.clear();
      }
    }
    this._map.clear();

    return this;
  }

  int get length {
    return this._map.length;
  }

  bool get isEmpty {
    return this._map.isEmpty;
  }
}
