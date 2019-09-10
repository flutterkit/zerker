import '../math/point.dart';
import '../node/image.dart';
import '../node/container.dart';

const int DEFAULT_TIME = 20 * 1000;

class ZKScrollBg extends ZKContainer {
  @override
  String type = "ZKScrollBg";

  @override
  bool interactive = false;

  Function onLoad;

  int time;
  int count;
  String direction;
  double bgFragWidth;
  double bgFragHeight;

  int _time;
  double _width;
  double _height;
  int _loadIndex = 0;
  bool _loaded = false;
  String _status = "play";
  List<ZKImage> _bgList = [];

  double get overWidth {
    return _width ?? this.context.appWidth;
  }

  double get overHeight {
    return _height ?? this.context.appHeight;
  }

  ////////////////////////////////////////////////////////////
  ///
  /// ZKImage constructor
  ///
  ////////////////////////////////////////////////////////////
  ZKScrollBg(
      {String key,
      String image,
      int total,
      int count = 2,
      double width,
      double height,
      int time = DEFAULT_TIME,
      String direction = 'left'})
      : super() {
    this.count = total ?? count;
    this._width = width;
    this._height = height;
    this._time = time;
    this.direction = direction;
    this.anchor = Point(0.0, 0.0);

    this._createBgList(key ?? image);
  }

  void play() {
    this._status = "play";
  }

  void stop() {
    this._status = "stop";
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Bg element initialization
  ///
  ////////////////////////////////////////////////////////////
  void _createBgList(String url) {
    for (int i = 0; i < count; i++) {
      ZKImage bgFrag = ZKImage(url);
      bgFrag.anchor = Point(0.0, 0.0);
      this._onLoad(bgFrag);
    }
  }

  void _onLoad(ZKImage bgFrag) {
    bgFrag.onLoad = (dynamic path) {
      this.bgFragWidth = bgFrag.width;
      this.bgFragHeight = bgFrag.height;
      this._loadIndex++;
      this.addChild(bgFrag);
      this._resetBgPosition(bgFrag, this._bgList.length);
      this._bgList.add(bgFrag);

      if (this._loadIndex >= count) {
        this._loaded = true;
        if (direction == "up" || direction == "down") {
          this.oriWidth = bgFragWidth;
        } else {
          this.oriHeight = bgFragHeight;
        }

        if (onLoad != null) onLoad();
        this.play();
      }
    };
  }

  void _resetBgPosition(ZKImage bgFrag, int index) {
    if (direction == "right") {
      bgFrag.position.x =
          overWidth - this._bgList.length * bgFragWidth + bgFragWidth * index;
    } else if (direction == "left") {
      bgFrag.position.x = bgFragWidth * index;
    } else if (direction == "down") {
      bgFrag.position.y = overHeight -
          this._bgList.length * bgFragHeight +
          bgFragHeight * index;
    } else if (direction == "up") {
      bgFrag.position.y = bgFragHeight * index;
    }
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Update function
  ///
  ////////////////////////////////////////////////////////////
  @override
  void update(int t) {
    if (this._status == "stop") return;
    if (this.visible == false) return;
    if (this._loaded == false) return;
    super.update(t);

    for (int i = 0; i < this._bgList.length; i++) {
      ZKImage bgFrag = this._bgList[i];

      if (direction == "left") {
        bgFrag.position.x -= (t / _time) * bgFragWidth;
        if (_headBg.position.x + bgFragWidth <= 0) {
          this._bgList.first.position.x =
              this._bgList.last.position.x + this._bgList.last.width;
          this._listReorder("->");
        }
      } else if (direction == "right") {
        bgFrag.position.x += (t / _time) * bgFragWidth;
        if (_headBg.position.x >= overWidth) {
          this._bgList.last.position.x =
              this._bgList.first.position.x - this._bgList.first.width;
          this._listReorder("<-");
        }
      } else if (direction == "up") {
        bgFrag.position.y -= (t / _time) * bgFragHeight;
        if (_headBg.position.y + bgFragHeight <= 0) {
          this._bgList.first.position.y =
              this._bgList.last.position.y + this._bgList.last.height;
          this._listReorder("->");
        }
      } else if (direction == "down") {
        bgFrag.position.y += (t / _time) * bgFragHeight;
        if (_headBg.position.y >= overHeight) {
          this._bgList.last.position.y =
              this._bgList.first.position.y - this._bgList.first.height;
          this._listReorder("<-");
        }
      }
    }
  }

  ////////////////////////////////////////////////////////////
  ///
  /// List related operations
  ///
  ////////////////////////////////////////////////////////////
  List<ZKImage> _listReorder([String dir = "->"]) {
    if (dir == "->") {
      this._bgList.add(this._bgList.first);
      this._bgList.removeAt(0);
    } else {
      this._bgList.insert(0, this._bgList.last);
      this._bgList.removeLast();
    }

    return this._bgList;
  }

  ZKImage get _headBg {
    if (direction == "left" || direction == "up") {
      return this._bgList.first;
    } else {
      return this._bgList.last;
    }
  }

  @override
  set debug(bool d) {
    this.forEach((bgFrag) => bgFrag.debug = d);
  }

  @override
  void dispose() {
    super.dispose();
    this.forEach((bgFrag) {
      bgFrag.dispose();
      (bgFrag as ZKImage).onLoad = null;
    });
  }
}
