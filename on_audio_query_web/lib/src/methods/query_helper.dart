import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:id3/id3.dart';
import 'dart:html' as html;

class QueryHelper {
  /// This method will get/load all audios files(mp3) from the user's [assets] folder.
  Future<List> getInternalFiles([String? path]) async {
    // Confirm that path isn't empty.
    if (path != null && path.isEmpty) return [];
    String assets = await rootBundle.loadString(path ?? 'AssetManifest.json');
    Map decoded = json.decode(assets);
    List files = decoded.keys.where((e) => e.endsWith(".mp3")).toList();
    return files;
  }

  /// This method will load a unique audio using his path, and return a [MP3Instance]
  /// with all information about this file.
  Future<MP3Instance> getMP3(String audio) async {
    // Before decode: assets/Jungle%20-%20Heavy,%20California.mp3
    // After decode: assets/Jungle - Heavy, California.mp3
    String decodedPath = Uri.decodeFull(audio);
    ByteData loadedAudio = await rootBundle.load(decodedPath);
    return MP3Instance(loadedAudio.buffer.asUint8List());
  }

  /// Code from: [device_info_plus](shorturl.at/mrswQ)
  String parseUserAgentToBrowserName() {
    if (html.window.navigator.userAgent.contains('Firefox')) {
      return "Firefox";
      // "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0"
    } else if (html.window.navigator.userAgent.contains('SamsungBrowser')) {
      return "SamsungBrowser";
      // "Mozilla/5.0 (Linux; Android 9; SAMSUNG SM-G955F Build/PPR1.180610.011) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/9.4 Chrome/67.0.3396.87 Mobile Safari/537.36
    } else if (html.window.navigator.userAgent.contains('Opera') ||
        html.window.navigator.userAgent.contains('OPR')) {
      return "Opera";
      // "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 OPR/57.0.3098.106"
    } else if (html.window.navigator.userAgent.contains('Trident')) {
      return "Trident";
      // "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; .NET4.0C; .NET4.0E; Zoom 3.6.0; wbx 1.0.0; rv:11.0) like Gecko"
    } else if (html.window.navigator.userAgent.contains('Edg')) {
      return "Edge";
      // https://docs.microsoft.com/en-us/microsoft-edge/web-platform/user-agent-string
      // "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.74 Safari/537.36 Edg/79.0.309.43"
      // "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36 Edge/16.16299"
    } else if (html.window.navigator.userAgent.contains('Chrome')) {
      return "Chrome";
      // "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/66.0.3359.181 Chrome/66.0.3359.181 Safari/537.36"
    } else if (html.window.navigator.userAgent.contains('Safari')) {
      return "Safari";
      // "Mozilla/5.0 (iPhone; CPU iPhone OS 11_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.0 Mobile/15E148 Safari/604.1 980x1306"
    } else {
      return "Unknown";
    }
  }
}
