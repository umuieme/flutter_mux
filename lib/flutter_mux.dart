import 'dart:async';

import 'package:flutter/services.dart';

class FlutterMux {
  static const MethodChannel _channel = const MethodChannel('flutter_mux');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('mixAudioVideo');
    return version;
  }

  static Future<bool> mixAudioAndVideo(
      String outputPath, String audioPath, String videoPath) async {
    final bool status = await _channel.invokeMethod('mixAudioVideo', {
      "outputPath": outputPath,
      "audioPath": audioPath,
      "videoPath": videoPath
    });
    return status;
  }
}
