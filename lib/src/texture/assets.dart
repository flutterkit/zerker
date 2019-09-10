import 'dart:ui' as ui;
import 'dart:async' show Future;
import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import './atlas.dart';
import './imgtexture.dart';
import './spritesheet.dart';
import '../utils/util.dart';
import '../utils/cachemap.dart';
import '../utils/imgloader.dart';

class ZKAssets {
  static CacheMap memCache = CacheMap();
  static String baseUrl = "";

  static String getPath(String path, [String baseUrl]) {
    if (path == null) return null;
    return baseUrl != null ? baseUrl + path : ZKAssets.baseUrl + path;
  }

  static dynamic getAsset(String key) {
    return memCache.getDataByKeyOrPath(key);
  }

  static void dispose() {
    return memCache.clear();
  }

  static String getType(dynamic texture) {
    if (texture is ui.Image) {
      return "image";
    } else if (texture is Atlas) {
      return "atlas";
    } else if (texture is SpriteSheet) {
      return "spritesheet";
    } else if (texture == null) {
      return null;
    }

    return "image";
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Basic assets loading method
  ///
  ////////////////////////////////////////////////////////////
  static Future<ByteData> loadByte(String path) async {
    path = ZKAssets.getPath(path);
    return await rootBundle.load(path);
  }

  static Future<String> loadString(String path) async {
    path = ZKAssets.getPath(path);
    return await rootBundle.loadString(path);
  }

  static Future<ui.Image> loadAssetImage(String path) async {
    path = ZKAssets.getPath(path);
    return await ImgLoader.loadFromAsset(path);
  }

  static Future<Map<String, dynamic>> loadJson(
      {String path,
      String key,
      String baseUrl,
      Function onLoad,
      Function onError,
      bool parse = true,
      bool cache = true}) async {
    path = ZKAssets.getPath(path, baseUrl);

    var f = (path) async {
      var jsonTxt = await ZKAssets.loadString(path);
      var result = parse == true ? json.decode(jsonTxt) : jsonTxt;

      return result;
    };

    return await memCache.load(
        path: path,
        key: key,
        cache: cache,
        load: f,
        onLoad: onLoad,
        onError: onError);
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Loading Texture Altas and using memory caching
  ///
  ////////////////////////////////////////////////////////////
  static Future<Atlas> loadAltas(
      {String json,
      String key,
      String image,
      String baseUrl,
      Function onLoad,
      Function onError,
      bool cache = true}) async {
    json = ZKAssets.getPath(json, baseUrl);
    image = ZKAssets.getPath(image, baseUrl);

    var f = (path) async {
      var content = await ZKAssets.loadJson(path: json, cache: false);
      var url = image ?? Util.getByPath(content, "meta.image");
      ui.Image img = await ZKAssets.loadAssetImage(url);
      Atlas result = Atlas(content, img);

      return result;
    };

    return await memCache.load(
        path: json,
        key: key,
        cache: cache,
        load: f,
        onLoad: onLoad,
        onError: onError);
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Loading SpriteSheet and using memory caching
  ///
  ////////////////////////////////////////////////////////////
  static Future<SpriteSheet> loadSpriteSheet(
      {String key,
      Size size,
      dynamic width,
      dynamic height,
      String image,
      String baseUrl,
      Function onLoad,
      Function onError,
      bool cache = true}) async {
    image = ZKAssets.getPath(image, baseUrl);

    var f = (path) async {
      ui.Image img = await ZKAssets.loadAssetImage(image);
      size = size ?? Size(width, height);
      var result = SpriteSheet(img, size);

      return result;
    };

    return await memCache.load(
        path: image,
        key: key,
        cache: cache,
        load: f,
        onLoad: onLoad,
        onError: onError);
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Loading Image and using memory caching
  ///
  ////////////////////////////////////////////////////////////
  static Future<ImgTexture> loadImage(
      {dynamic path,
      dynamic image,
      dynamic url,
      String baseUrl,
      String key,
      Function onLoad,
      Function onError,
      bool cache = true}) async {
    var href = path ?? image ?? url;
    href = ZKAssets.getPath(href, baseUrl);

    var f = (path) async {
      ui.Image img = await ImgLoader.load(path: path);
      return ImgTexture(img);
    };

    return await memCache.load(
        path: href,
        key: key,
        cache: cache,
        load: f,
        onLoad: onLoad,
        onError: onError);
  }

  ////////////////////////////////////////////////////////////
  ///
  /// Loading a bunch of Assets, usually for preloading
  ///
  ////////////////////////////////////////////////////////////
  static void preload(
      {Map urls,
      String baseUrl,
      int parallel = 8,
      Function onLoad,
      Function onProgress,
      Function onError}) {
    int index = 0;
    int loadNum = 0;
    double scale = 0;
    List urlsList = [];
    bool loaded = false;
    Function singleLoad;

    Function convertToList = () {
      urls.forEach((key, url) {
        Map obj = {};
        obj["key"] = key;
        if (url is String) {
          if (Util.getSuffix(url) == 'img')
            obj["type"] = "image";
          else
            obj["type"] = "json";
          obj["url"] = url;
        } else if (url is Map) {
          if (url["json"] != null)
            obj["type"] = "atlas";
          else
            obj["type"] = "spritesheet";
          obj.addAll(url);
        }

        urlsList.add(obj);
      });
    };

    Function checkLoaded = () {
      scale = min(loadNum / urlsList.length, 1);
      onProgress(scale);

      if (loadNum >= urlsList.length && loaded != true) {
        loaded = true;
        if (onLoad != null) onLoad();
      }
    };

    Function errorHandler = ([err]) {
      loadNum++;
      checkLoaded();
      singleLoad();
      if (onError != null) onError();
    };

    Function loadHandler = ([result]) {
      loadNum++;
      checkLoaded();
      singleLoad();
    };

    singleLoad = () {
      if (loaded) return;
      if (index >= urlsList.length) return;

      Map obj = urlsList[index++];
      String type = obj["type"];

      switch (type) {
        case "image":
          ZKAssets.loadImage(
              key: obj["key"],
              path: obj["url"],
              baseUrl: baseUrl,
              onLoad: loadHandler,
              onError: errorHandler);
          break;

        case "json":
          ZKAssets.loadJson(
              key: obj["key"],
              path: obj["url"],
              baseUrl: baseUrl,
              onLoad: loadHandler,
              onError: errorHandler,
              parse: false);
          break;

        case "atlas":
          ZKAssets.loadAltas(
              key: obj["key"],
              json: obj["json"],
              baseUrl: baseUrl,
              image: obj["image"],
              onLoad: loadHandler,
              onError: errorHandler);
          break;

        case "spritesheet":
          ZKAssets.loadSpriteSheet(
              key: obj["key"],
              width: obj["width"],
              height: obj["height"],
              image: obj["image"],
              baseUrl: baseUrl,
              onLoad: loadHandler,
              onError: errorHandler);
          break;
      }
    };

    /// begin s load
    convertToList();
    int length = min(parallel, urlsList.length);
    for (int i = 0; i < length; i++) {
      singleLoad();
    }
  }
}
