////////////////////////////////////////////////////////////
///
/// CacheMap
///
////////////////////////////////////////////////////////////
class CacheMap {
  Map<String, dynamic> map = {};

  bool has(String key) {
    if (map[key] != null) return true;
    return false;
  }

  dynamic getVal(String key) {
    return map[key];
  }

  void setVal(String key, dynamic val) {
    map[key] = val;
  }

  void setData({String key, dynamic data, String path}) {
    var id = key ?? path;
    map[id] = {
      "key": key,
      "path": path,
      "data": data,
    };
  }

  bool hasByKeyOrPath(String key) {
    return getByKeyOrPath(key) != null;
  }

  dynamic getByKeyOrPath(String key) {
    return getByKey(key) ?? getByPath(key);
  }

  dynamic getDataByKeyOrPath(String key) {
    var obj = getByKeyOrPath(key);
    return obj != null ? obj["data"] : null;
  }

  dynamic getByKey(String key) {
    if (key == null) return null;
    return map[key];
  }

  dynamic getByPath(String path) {
    if (path == null) return null;

    for (var key in map.keys) {
      var obj = map[key];
      if (obj != null && obj["path"] == path) {
        return obj;
      }
    }

    return null;
  }

  ////////////////////////////////////////////////////////////
  ///
  /// load any asset by Cache
  ///
  ////////////////////////////////////////////////////////////
  dynamic load(
      {dynamic path,
      String key,
      Function load,
      Function onLoad,
      Function onError,
      bool cache = true}) async {
    dynamic result = this.getDataByKeyOrPath(key ?? path);
    if (cache && result != null) {
      if (onLoad != null) onLoad(result);
      return result;
    }

    try {
      if (path != null && path is String) {
        var data = await load(path);
        if (cache) this.setData(key: key, path: path, data: data);
        if (onLoad != null) onLoad(data);

        return data;
      } else {
        if (cache) this.setData(key: key, data: path, path: null);
        if (onLoad != null) onLoad(path);

        return path;
      }
    } catch (e) {
      print(e);
      if (onError != null) onError(e);
    }
  }

  void clear() {
    map.clear();
  }
}
