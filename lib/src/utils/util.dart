import './uuid.dart';

class Util {
  ////////////////////////////////////////////////////////////
  ///
  /// Determine if it is a URL
  ///
  ////////////////////////////////////////////////////////////
  static bool isNetUrl(String url) {
    RegExp reg = RegExp(r"(https?|ftp):\/\/([\w.]+\/?)\S*");
    return reg.hasMatch(url);
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Get the suffix name
  ///
  ////////////////////////////////////////////////////////////
  static String getSuffix(String url) {
    if (RegExp(r"(.*)\.(jpg|bmp|gif|ico|pcx|jpeg|tif|png)$").hasMatch(url)) {
      return "img";
    } else if (RegExp(r"(.*)\.(json)$").hasMatch(url)) {
      return "json";
    } else {
      return "img";
    }
  }

  static String uuid() {
    return Uuid().v4();
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Compatible loop function
  ///
  ////////////////////////////////////////////////////////////
  static void forEach(dynamic obj, Function func) {
    if (obj is List) {
      for (int i = 0; i < obj.length; i++) {
        func(obj[i], i);
      }
    } else if (obj is Map) {
      obj.forEach((var k, var v) {
        func(v, k);
      });
    }
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Convert special arrays to numeric arrays
  ///  - ['2-5'] => [2,3,4,5]
  ///  - ['run{1-3}.jpg'] => ["run1.jpg", "run2.jpg", "run3.jpg"]
  ///
  ////////////////////////////////////////////////////////////
  static List convertConsecutiveList(List arr, [String? prefix]) {
    if (arr.length == 1 && arr[0] is String) {
      String str = arr[0];
      RegExp exp1 = RegExp(r"^([0-9]*)\-([0-9]*)$");
      RegExp exp2 = RegExp(r"{([0-9]*)\-([0-9]*)}");

      if (exp1.hasMatch(str) || exp2.hasMatch(str)) {
        List result = [];
        int a = 0, b = 0;

        if (exp1.hasMatch(str)) {
          List ints = str.split("-");
          a = int.parse(ints[0]);
          b = int.parse(ints[1]);

          for (var i = a; i <= b; i++) {
            result.add(i);
          }
        } else if (exp2.hasMatch(str)) {
          Iterable<Match> matches = exp2.allMatches(str);
          for (Match m in matches) {
            String? s = m.group(0);
            if (s == null) continue;
            s = s.replaceAll("{", "").replaceAll("}", "");
            List ints = s.split("-");
            a = int.parse(ints[0]);
            b = int.parse(ints[1]);
          }

          for (int i = a; i <= b; i++) {
            result.add(str.replaceAll(exp2, "$i"));
          }
        }

        return result;
      }
    }

    return arr;
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Quick access to property mode.
  ///  - getByPath({ "a": null }, 'a.b.c')
  ///
  ////////////////////////////////////////////////////////////
  static dynamic getByPath(dynamic data, String path, [dynamic defaultVal]) {
    List paths = path.split(".");
    var resultVal;

    data.forEach((String key, val) {
      if (key == paths[0]) {
        if (paths.length == 1) {
          resultVal = val;
          return;
        }

        paths.remove(key);

        if (val == null) {
          resultVal = defaultVal;
          return;
        }

        try {
          resultVal = Util.getByPath(val, paths.join("."), defaultVal);
        } catch (error) {
          resultVal = defaultVal;
        }
        return;
      }
    });

    return resultVal ?? defaultVal;
  }

  static dynamic getListVal(List? list, int key) {
    if (list == null) return null;

    int index = key >= list.length ? list.length - 1 : key;
    return list[index];
  }

  static void fullScreen() {
    //SystemChrome.setEnabledSystemUIMode();
    //SystemChrome.setEnabledSystemUIOverlays([]);
  }
}
