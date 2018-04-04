import 'dart:async';

import 'package:flutter/services.dart';

class PlatformChannel {
  static const _channelName = 'diov.github.io/threes_channel';

  static const methodChannel = const MethodChannel(_channelName);

  static Future<Null> displayGameScore(int score) async {
    try {
      final Object result =
          await methodChannel.invokeMethod("displayGameScore", score);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  /// TODO: finish matrix game over algorithm.
  static Future<Null> displayGameOver() async {
    try {
      final Object result =
      await methodChannel.invokeMethod("displayGameOver");
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  static const BasicMessageChannel<String> messageChannel =
      const BasicMessageChannel<String>(_channelName, const StringCodec());
}
