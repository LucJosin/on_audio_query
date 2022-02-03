
import 'dart:async';

import 'package:flutter/services.dart';

class OnAudioQueryWindows {
  static const MethodChannel _channel = MethodChannel('on_audio_query_windows');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
