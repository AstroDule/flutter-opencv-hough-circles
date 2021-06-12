/* 
 * Copyright (c) 2021 fgsoruco.
 * See LICENSE for more details.
 */
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:opencv_4/factory/pathfrom.dart';
import 'package:opencv_4/factory/utils.dart';

///Class for process [HoughCircles]
class HoughCirclesFactory {
  static const platform = const MethodChannel('opencv_4');
  static String name = 'houghCircles';

  static Future<Uint8List?> houghCircles({
    required CVPathFrom pathFrom,
    required String pathString,
    required int method,
    required double dp,
    required double minDist,
    required double param1,
    required double param2,
    required int minRadius,
    required int maxRadius,
    int centerWidth = 28,
    String centerColor = "#FF0000",
    int circleWidth = 28,
    String circleColor = "#FFFFFFF"
  }) async {
    File _file;
    Uint8List _fileAssets;

    Uint8List? result;

    switch (pathFrom) {
      case CVPathFrom.GALLERY_CAMERA:
        result = await platform.invokeMethod(name, {
          "pathType": 1,
          "pathString": pathString,
          "data": Uint8List(0),

          'method': method,
          'dp': dp,
          'minDist': minDist,
          'param1': param1,
          'param2': param2,
          'minRadius': minRadius,
          'maxRadius': maxRadius,
          'centerWidth': centerWidth,
          'centerColor': centerColor,
          'circleWidth': circleWidth,
          'circleColor': circleColor,
        });
        break;
      case CVPathFrom.URL:
        _file = await DefaultCacheManager().getSingleFile(pathString);
        result = await platform.invokeMethod(name, {
          "pathType": 2,
          "pathString": '',
          "data": await _file.readAsBytes(),

          'method': method,
          'dp': dp,
          'minDist': minDist,
          'param1': param1,
          'param2': param2,
          'minRadius': minRadius,
          'maxRadius': maxRadius,
          'centerWidth': centerWidth,
          'centerColor': centerColor,
          'circleWidth': circleWidth,
          'circleColor': circleColor,
        });

        break;
      case CVPathFrom.ASSETS:
        _fileAssets = await Utils.imgAssets2Uint8List(pathString);
        result = await platform.invokeMethod(name, {
          "pathType": 3,
          "pathString": '',
          "data": _fileAssets,

          'method': method,
          'dp': dp,
          'minDist': minDist,
          'param1': param1,
          'param2': param2,
          'minRadius': minRadius,
          'maxRadius': maxRadius,
          'centerWidth': centerWidth,
          'centerColor': centerColor,
          'circleWidth': circleWidth,
          'circleColor': circleColor,
        });
        break;
    }

    return result;
  }
}
