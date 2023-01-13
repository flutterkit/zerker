import 'dart:ui' as ui;
import 'dart:async' show Future, Completer, Timer;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/painting.dart';

import '../utils/util.dart';

class ImgLoader {
  ////////////////////////////////////////////////////////////
  ///
  /// Load asset or network Image
  ///
  ////////////////////////////////////////////////////////////
  static Future<ui.Image> load(
      {String path = "",
      Function? onLoad,
      Function? onError,
      int timeout: 5000}) async {
    ImageStream stream;
    ImageConfiguration imgConf = ImageConfiguration.empty;
    Completer<ui.Image> completer = Completer<ui.Image>();

    if (Util.isNetUrl(path)) {
      stream = NetworkImage(path).resolve(imgConf);
    } else {
      stream = AssetImage(path, bundle: rootBundle).resolve(imgConf);
    }

    /// Image Listener ----------------------------------------
    Timer? timer;
    ImageStreamListener? listener;

    // remove listener
    var removeListener = () {
      stream.removeListener(listener!);
      timer?.cancel();
    };

    var onLoadHandler = (ImageInfo info, bool _) async {
      completer.complete(info.image);
      removeListener();
      if (onLoad != null) onLoad(path);
    };
    var onErrorHandler = (dynamic exception, StackTrace? stackTrace) {
      completer.completeError(exception, stackTrace);
      removeListener();
      if (onError != null) onError(exception);
    };

    timer = Timer(Duration(milliseconds: timeout), () {
      completer.completeError("timeout");
      removeListener();
      if (onError != null) onError("timeout");
    });

    listener = new ImageStreamListener(onLoadHandler, onError: onErrorHandler);
    stream.addListener(listener);

    return await completer.future;
  }

  ////////////////////////////////////////////////////////////
  ///
  /// load asset Image
  ///
  ////////////////////////////////////////////////////////////
  static Future<ui.Image> loadFromAsset(String path) async {
    var data = await rootBundle.load(path);
    var codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    var frame = await codec.getNextFrame();

    return frame.image;
  }
}
